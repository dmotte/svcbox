#!/usr/bin/env python3

import sys


# Inspired by "/usr/share/doc/supervisor/examples/sample_eventlistener.py" on
# Debian 13 (trixie), and
# https://github.com/coderanger/supervisor-stdout/blob/master/supervisor_stdout.py


def write_stdout(s: str) -> None:
    sys.stdout.write(s)
    sys.stdout.flush()


def write_stderr(s: str) -> None:
    sys.stderr.write(s)
    sys.stderr.flush()


def main() -> int:
    while True:
        # Transition from ACKNOWLEDGED to READY
        write_stdout('READY\n')

        headers_line = sys.stdin.readline()
        if headers_line == '':
            break  # EOF
        headers = dict(x.split(':', 1) for x in headers_line.split())

        data_str = sys.stdin.read(int(headers['len']))  # Event payload
        data_bytes = data_str.encode('utf-8')

        # Transition from READY to ACKNOWLEDGED
        write_stdout(f'RESULT {len(data_bytes)}\n{data_str}')

    return 0
