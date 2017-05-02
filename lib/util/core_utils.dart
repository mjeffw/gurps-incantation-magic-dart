String toSignedString(int x) {
  if (x < 0) {
    return x.toString();
  } else {
    return '+${x}';
  }
}
