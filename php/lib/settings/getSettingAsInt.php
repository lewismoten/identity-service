<?php
require_once __DIR__ .'/getSetting.php';
function getSettingAsInt(string $category, string $name, int $default = 0) {
  return (int)getSetting($category, $name, (string)$default);
}