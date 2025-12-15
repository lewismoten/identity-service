<?php
function clamp(int $val, int $min, int $max): int {
  return $val < $min ? $min : $val > $max ? $max : $val;
}
