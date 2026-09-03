#!/usr/bin/env python3

from typing import TextIO

from supervisor.events import ProcessLogEvent


def exec(event: ProcessLogEvent, headers: dict[str, str],
         text_lines: list[str], file_out: TextIO) -> None:
    prefix = f'logtosupd {headers['processname']} {headers['channel']} | '
    print('\n'.join(f'{prefix}{line}' for line in text_lines), file=file_out)
