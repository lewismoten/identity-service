<?php
function getSetting(string $category, string $name, string $default = ''): string {
  $val = db()
    ->prepare("SELECT value FROM system_settings WHERE category=? AND name=? LIMIT 1")
    ->execute([$category, $name])
    ->fetchColumn();
  return ($val === false || $val === null) ? $default : (string)$val;
}