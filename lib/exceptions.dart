class Errors {
  static String goster(String hatakodu) {
    switch (hatakodu) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return "Bu mail adresi kullanımda";
      default:
        return "Bir hata oluştu";
    }
  }
}
