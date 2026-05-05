// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get changeTheme => 'Ganti Warna Tema';

  @override
  String get feedback => 'Umpan Balik dan Saran';

  @override
  String get changeLanguage => 'Ganti Bahasa';

  @override
  String get allFriendsTitle => 'Semua Teman';

  @override
  String get noFriendsMessage => 'Anda belum memiliki teman apa pun.';

  @override
  String get unknownCharacter => 'Karakter tidak dikenal';

  @override
  String errorLoadingFriends(String error) {
    return 'Terjadi kesalahan saat memuat daftar teman: $error';
  }

  @override
  String get tagGentle => 'Lembut';

  @override
  String get tagCheerful => 'Ceria';

  @override
  String get tagLively => 'Hidup';

  @override
  String get tagMischievous => 'Nakal';

  @override
  String get tagRichYoungLady => 'Nona Muda';

  @override
  String get tagRichYoungMaster => 'Tuan Muda';

  @override
  String get tagWealthyFamily => 'Keluarga Kaya';

  @override
  String get tagScheming => 'Licik';

  @override
  String get tagPossessive => 'Posesif';

  @override
  String get tagParanoid => 'Paranoid';

  @override
  String get tagPersistent => 'Gigih';

  @override
  String get tagUncle => 'Paman';

  @override
  String get tagAuntie => 'Bibi';

  @override
  String get tagSeniorSister => 'Kakak Kelas (Perempuan)';

  @override
  String get tagJuniorBrother => 'Adik Kelas (Laki-laki)';

  @override
  String get tagHandsome => 'Tampan';

  @override
  String get tagStunning => 'Sangat Cantik';

  @override
  String get tagContrast => 'Kontras';

  @override
  String get tagFlirty => 'Menggoda';

  @override
  String get tagAgeGap => 'Perbedaan Usia';

  @override
  String get userNotFoundError => 'Pengguna tidak ditemukan';

  @override
  String get imageDataMismatchError =>
      'Data gambar tidak konsisten, silakan pilih gambar lagi.';

  @override
  String get createCharacterTitle => 'Buat Karakter';

  @override
  String get charAlbumTitle =>
      'Album Karakter (Gambar pertama adalah avatar utama)';

  @override
  String get charNameLabel => 'Nama Karakter:*';

  @override
  String get charDescSection => 'Deskripsi Karakter:';

  @override
  String get charAgeLabel => 'Usia:';

  @override
  String get charJobLabel => 'Pekerjaan:*';

  @override
  String get charBirthdayLabel => 'Tanggal Lahir:(MMDD)';

  @override
  String get charGenderLabel => 'Jenis Kelamin *';

  @override
  String get genderNotSelected => 'Belum Dipilih';

  @override
  String get genderMale => 'Laki-laki';

  @override
  String get genderFemale => 'Perempuan';

  @override
  String get genderOther => 'Lainnya';

  @override
  String get charHeightLabel => 'Tinggi:(cm)';

  @override
  String get charAppearanceLabel => 'Deskripsi Penampilan:';

  @override
  String get charPersonalityTagsSection => 'Tag Kepribadian';

  @override
  String get charOtherPersonalityTagsHint => 'Tag kepribadian lainnya...';

  @override
  String get otherSectionTitle => 'Lainnya';

  @override
  String get charLikesLabel =>
      'Hal yang disukai:(contoh: kue stroberi, kucing, hari hujan)';

  @override
  String get charDislikesLabel =>
      'Hal yang tidak disukai:(contoh: pare, tempat yang bising)';

  @override
  String get charSecretsLabel =>
      'Rahasia kecil yang tidak diketahui: (contoh: sebenarnya buta arah)';

  @override
  String get charMannerismsSection => 'Tingkah laku';

  @override
  String get charToneLabel =>
      'Nada dan gaya bicara: (contoh: dingin kepada orang asing)';

  @override
  String get charDialogueExampleLabel =>
      'Contoh dialog: (Pemain: Kamu baik sekali! Karakter: ...Oh.)';

  @override
  String get charBackgroundSection => 'Latar Belakang Karakter:';

  @override
  String get charBackgroundHint =>
      'Masukkan cerita latar belakang karakter (maksimal 2500 kata)';

  @override
  String get charStoryStartSection => 'Awal Cerita:';

  @override
  String get charStoryStartHint =>
      'Masukkan plot cerita karakter (maksimal 2500 kata)';

  @override
  String get charStorySummaryLabel =>
      'Ringkasan Cerita (maksimal 50 kata, akan ditampilkan di kartu pertemuan)';

  @override
  String get charExtraInfoSection => 'Informasi Tambahan Karakter:';

  @override
  String get charExtraInfoHint => 'Masukkan konten tambahan...';

  @override
  String get charPublicToggleLabel =>
      'Apakah akan dipublikasikan agar pemain lain bisa memainkannya?';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get createButton => 'Buat';

  @override
  String get saveButton => 'Simpan';

  @override
  String get cancelButton => 'Batal';

  @override
  String get exitCreationTitle =>
      'Anda akan keluar dari layar pembuatan karakter';

  @override
  String get saveDraftPrompt => 'Perlu disimpan sebagai draf?';

  @override
  String get draftNeeded => 'Ya';

  @override
  String get draftNotNeeded => 'Tidak';

  @override
  String get editExtraInfoTitle => 'Edit Konten Tambahan';

  @override
  String get nameAndAvatarError =>
      'Silakan isi nama karakter dan unggah setidaknya satu avatar!';

  @override
  String get savingStatus => 'Sedang menyimpan...';

  @override
  String get uploadingImagesStatus => 'Sedang mengunggah gambar...';

  @override
  String get maxImagesError => 'Hanya dapat mengunggah maksimal 10 gambar.';

  @override
  String get uploadingImagesStatusShort => 'Sedang memproses gambar...';

  @override
  String get savingCharacterData => 'Sedang menyimpan data karakter...';

  @override
  String characterCreatedSuccess(String charName) {
    return 'Karakter \"$charName\" berhasil dibuat!';
  }

  @override
  String get uploadImageTimeoutError =>
      'Gagal membuat karakter: Waktu unggah gambar habis, mohon periksa koneksi internet Anda.';

  @override
  String createCharacterGenericError(String error) {
    return 'Gagal membuat karakter: $error';
  }

  @override
  String get settingsSectionAppearance => 'Penampilan dan Konten';

  @override
  String get settingsSectionAccount => 'Manajemen Akun dan Konten';

  @override
  String get settingsSectionAbout => 'Tentang Kami';

  @override
  String get accountManagement => 'Manajemen Akun';

  @override
  String get userId => 'ID:';

  @override
  String get authMethodGoogle => 'Google';

  @override
  String get authMethodUnknown => 'Tidak Diketahui';

  @override
  String get userIdCopied => 'ID Pengguna telah disalin ke papan klip';

  @override
  String get characterManagement => 'Manajemen Karakter';

  @override
  String get viewBlockedCharacters => 'Lihat Karakter yang Diblokir';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get termsOfService => 'Ketentuan Layanan';

  @override
  String get logoutButton => 'Keluar';

  @override
  String get logoutDialogTitle => 'Anda yakin ingin keluar?(´;ω;`)';

  @override
  String get logoutDialogActionCancel => 'Saya salah tekan';

  @override
  String get logoutDialogActionConfirm => 'Konfirmasi';

  @override
  String get logoutSuccessSnackbar =>
      'Baik! Saya akan menunggu Anda kembali♥(´∀` )';

  @override
  String get deleteAccountButton => 'Hapus Akun';

  @override
  String get deleteAccountDialogTitle =>
      'Anda yakin ingin menghapus akun ini?இдஇ';

  @override
  String get deleteAccountDialogContent =>
      'Tindakan ini tidak dapat dibatalkan, semua data akan dihapus secara permanen!';

  @override
  String get deleteAccountDialogActionCancel =>
      'Tidak, saya tidak ingin menghapus';

  @override
  String get deleteAccountDialogActionConfirm => 'Konfirmasi';

  @override
  String get deleteAccountSuccessSnackbar => 'Akun berhasil dihapus.';

  @override
  String get appDisclaimer =>
      'Karakter dan adegan dalam game ini adalah fiksi, jangan diterapkan pada kenyataan! Jika ada kesamaan, itu murni kebetulan.';

  @override
  String appVersion(String version) {
    return 'Versi Aplikasi: $version';
  }

  @override
  String get dialogTitleHint => 'Petunjuk';

  @override
  String get completeProfilePrompt =>
      'Silakan edit profil Anda untuk melengkapi informasi Anda terlebih dahulu!';

  @override
  String get goToEdit => 'Pergi ke Edit';

  @override
  String get later => 'Nanti';

  @override
  String chattingWith(String friendName) {
    return 'Mengobrol dengan $friendName';
  }

  @override
  String chatContentWith(String friendName) {
    return 'Isi obrolan dengan $friendName';
  }

  @override
  String get chatInputHint => 'Masukkan pesan...';
}
