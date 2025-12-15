<?php
require_once __DIR__ .'/getSettingAsInt.php';
function getSettingAsBool(string $category, string $name, bool $default = false): bool {
  return getSettingAsInt($category, $name, (string)$default) === 1;
}