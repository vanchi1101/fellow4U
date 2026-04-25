import 'dart:convert';
import 'dart:io';

class SqlServerDatabase {
  SqlServerDatabase({
    String? serverInstance,
    String? databaseName,
    String? username,
    String? password,
  }) : serverInstance =
           serverInstance ??
           Platform.environment['DB_SERVER_INSTANCE'] ??
           r'.\SQLEXPRESS',
       databaseName =
           databaseName ?? Platform.environment['DB_NAME'] ?? 'fellow_db',
       username = username ?? Platform.environment['DB_USER'] ?? 'sa',
       password = password ?? Platform.environment['DB_PASSWORD'] ?? '749516';

  final String serverInstance;
  final String databaseName;
  final String username;
  final String password;

  Future<List<dynamic>> queryList(
    String query, {
    String? overrideDatabaseName,
  }) async {
    final result = _normalizeResult(
      await _runQuery(
      query,
      overrideDatabaseName: overrideDatabaseName,
      ),
    );

    if (result == null) {
      return <dynamic>[];
    }

    if (result is List) {
      return result;
    }

    return <dynamic>[result];
  }

  Future<Map<String, dynamic>?> queryObject(
    String query, {
    String? overrideDatabaseName,
  }) async {
    final result = _normalizeResult(
      await _runQuery(
      query,
      overrideDatabaseName: overrideDatabaseName,
      ),
    );

    if (result == null) {
      return null;
    }

    if (result is List) {
      if (result.isEmpty) {
        return null;
      }
      return Map<String, dynamic>.from(result.first as Map);
    }

    return Map<String, dynamic>.from(result as Map);
  }

  Future<dynamic> _runQuery(
    String query, {
    String? overrideDatabaseName,
  }) async {
    final database = overrideDatabaseName ?? databaseName;
    final encodedQuery = base64Encode(utf8.encode(query));
    final script =
        '''
        \$ErrorActionPreference = 'Stop'
        Import-Module SQLPS -DisableNameChecking | Out-Null
        \$query = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("${_escapePowerShell(encodedQuery)}"))
        \$result = Invoke-Sqlcmd -ServerInstance "${_escapePowerShell(serverInstance)}" -Database "${_escapePowerShell(database)}" -Username "${_escapePowerShell(username)}" -Password "${_escapePowerShell(password)}" -QueryTimeout 30 -Query \$query
        \$rows = @()
        if (\$null -ne \$result) {
          \$rows = @(\$result | ForEach-Object {
            \$row = @{}
            foreach (\$column in \$_.Table.Columns) {
              \$row[\$column.ColumnName] = \$_[\$column.ColumnName]
            }
            [PSCustomObject]\$row
          })
        }
        if (\$rows.Count -eq 0) {
          Write-Output 'null'
        } else {
          \$rows | ConvertTo-Json -Depth 5 -Compress
        }
      ''';

    final process = await Process.run('powershell', <String>[
      '-NoProfile',
      '-EncodedCommand',
      base64Encode(Utf16Le.encode(script)),
    ]);

    if (process.exitCode != 0) {
      final stderr = (process.stderr as String).trim();
      throw StateError(
        stderr.isEmpty
            ? 'Database query failed with exit code ${process.exitCode}'
            : stderr,
      );
    }

    final stdout = (process.stdout as String).trim();
    if (stdout.isEmpty || stdout == 'null') {
      return null;
    }

    return jsonDecode(stdout);
  }

  static String sqlString(String value) => "N'${value.replaceAll("'", "''")}'";

  static String _escapePowerShell(String value) {
    return value.replaceAll('`', '``').replaceAll('"', '`"');
  }

  dynamic _normalizeResult(dynamic value) {
    if (value is Map) {
      final mapped = value.map(
        (key, item) => MapEntry('$key', _normalizeResult(item)),
      );

      if (mapped.length == 1) {
        final singleKey = mapped.keys.first;
        final singleValue = mapped.values.first;
        if (singleKey.startsWith('JSON_') && singleValue is String) {
          return _normalizeResult(jsonDecode(singleValue));
        }
      }

      return mapped;
    }

    if (value is List) {
      return value.map(_normalizeResult).toList();
    }

    if (value is String) {
      final trimmed = value.trim();
      if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
          (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
        try {
          return _normalizeResult(jsonDecode(trimmed));
        } catch (_) {
          return value;
        }
      }
    }

    return value;
  }
}

class Utf16Le {
  static List<int> encode(String input) {
    final codeUnits = input.codeUnits;
    final bytes = <int>[];
    for (final unit in codeUnits) {
      bytes.add(unit & 0xff);
      bytes.add((unit >> 8) & 0xff);
    }
    return bytes;
  }
}
