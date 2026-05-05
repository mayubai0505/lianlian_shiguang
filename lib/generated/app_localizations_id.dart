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

  @override
  String get characterNotFoundError => 'Data karakter tidak ditemukan';

  @override
  String errorLoadingCharacterDetails(String errorDetails) {
    return 'Gagal memuat detail karakter: $errorDetails';
  }

  @override
  String get charInitialRelationshipLabel => 'Hubungan awal';

  @override
  String get relationship_childhood_friend => 'Teman masa kecil';

  @override
  String get relationship_senior_junior => 'Kakak/adik kelas';

  @override
  String get relationship_bickering_couple => 'Pasangan yang suka bertengkar';

  @override
  String get relationship_colleagues => 'Rekan kerja';

  @override
  String get relationship_other => 'Lainnya (silakan masukkan secara manual)';

  @override
  String get chatModeDaily => 'Mode Harian';

  @override
  String get chatModeStory => 'Mode Cerita';

  @override
  String get chatModeImmersive => 'Mode Imersif';

  @override
  String get chatModeGemini => 'Pendamping Hidup';

  @override
  String get announcement_new => 'Pengumuman Baru';

  @override
  String get mail_notification =>
      'Surat Waktu baru telah tiba! Segera periksa Gulungan Perkamen!';

  @override
  String get customer_service_reply => 'Balasan Layanan Pelanggan';

  @override
  String get system_announcement => 'Pengumuman Sistem';

  @override
  String get empty_announcement => 'Saat ini tidak ada pengumuman.';

  @override
  String get untitled => 'Tanpa Judul';

  @override
  String get no_content => 'Tidak Ada Konten';

  @override
  String get privacy_policy_title => 'Kebijakan Privasi Lianlian Shiguang';

  @override
  String get privacy_policy_date => 'Pembaruan Terakhir: 10 April 2026';

  @override
  String get privacy_policy_body =>
      'Kebijakan Privasi \"Lianlian Shiguang\"\nTerakhir Diperbarui: 10 April 2026\n\nSelamat datang di \"Lianlian Shiguang\" (selanjutnya disebut \"Layanan\"). Kami sangat menghargai privasi Anda. Kebijakan ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi pribadi Anda.\n\n1. Informasi Akun:\nLogin Pihak Ketiga: Saat login melalui Google, Facebook, atau Apple, kami mengumpulkan Firebase UID, email, dan nama panggilan publik Anda.\nRegistrasi Email: Jika menggunakan email, kami mengumpulkan alamat email Anda. Kata sandi dikelola dan disimpan melalui enkripsi Firebase; tim pengembang tidak dapat melihat kata sandi asli Anda.\n\nData Interaksi: Agar karakter AI memiliki memori berkelanjutan, kami menyimpan riwayat percakapan Anda dengan AI dan konten yang Anda tulis untuk karakter dalam game.\n\nInformasi Perangkat: Termasuk model perangkat, versi sistem operasi, dan pengenal unik perangkat untuk optimasi sistem.\n\n2. Penggunaan Informasi:\nOptimalisasi AI: Menggunakan riwayat percakapan untuk meningkatkan kualitas respons dan konsistensi kepribadian AI.\nOperasi Layanan: Digunakan untuk memproses pengisian poin, catatan konsumsi, dan verifikasi identitas.\nKeamanan: Memantau perilaku berbahaya untuk melindungi server.\n\n3. Kerja Sama Teknis Pihak Ketiga:\nLayanan ini didukung oleh: Google Cloud / Firebase (Penyimpanan & Autentikasi), OpenRouter / xAI / Meta (Logika AI).\nCatatan: Kami tidak menjual riwayat percakapan asli Anda kepada pengiklan.\n\n4. Penyimpanan & Penghapusan Data:\nData disimpan dengan aman di server cloud. Anda dapat menghubungi kami kapan saja untuk meminta penghapusan permanen akun dan semua data terkait.';

  @override
  String get terms_title => 'Ketentuan Layanan Lianlian Shiguang';

  @override
  String get terms_date => 'Pembaruan Terakhir: 10 April 2026';

  @override
  String get terms_body =>
      'Ketentuan Layanan \"Lianlian Shiguang\"\nTerakhir Diperbarui: 10 April 2026\n\nHarap baca ketentuan berikut dengan saksama sebelum menggunakan Layanan. Dengan menggunakan Layanan, Anda setuju dengan hal berikut:\n\n1. Sifat Layanan & Penyangkalan:\nInteraksi Non-Manusia: Semua respons karakter dihasilkan oleh AI (Generative AI). Pernyataan karakter tidak mewakili posisi pengembang.\nRisiko Narasi: AI dapat menghasilkan konten fiktif atau tidak akurat. Pengguna harus mampu membedakan fiksi dan realitas.\n\n2. Poin Virtual & Pembayaran:\nSifat Poin: Poin adalah barang virtual. Setelah dikonsumsi (seperti masuk ke cerita, mode imersif, hadiah, panggilan suara), poin tidak dapat dikembalikan.\nBiaya: Standar konsumsi poin ditetapkan berdasarkan biaya komputasi AI.\n\n3. Kode Etik Pengguna:\nDilarang menggunakan AI untuk menghasilkan konten kekerasan ekstrem, panduan kriminal, atau melanggar hukum.\n\n4. Hak Kekayaan Intelektual:\nKonten Orisinal: Nama karakter (seperti Cheng An), latar belakang, dan naskah adalah milik \"Tim Pengembang Lianlian Shiguang\".\nKonten Hasil AI: Beberapa gambar dihasilkan oleh alat AI (seperti Niji.journey) dengan lisensi komersial yang sah.\n\n5. Penghentian Layanan:\nPelanggaran ketentuan dapat menyebabkan penangguhan akun tanpa pemberitahuan sebelumnya.';

  @override
  String get login_required => 'Silakan login terlebih dahulu';

  @override
  String get cloud_character_mgmt => 'Manajemen Karakter Cloud';

  @override
  String get connection_error => 'Kesalahan Koneksi';

  @override
  String get no_characters_met => 'Anda belum bertemu karakter apa pun!';

  @override
  String get status_paused => 'Status: Kontak Ditangguhkan';

  @override
  String get status_in_progress => 'Status: Dalam Proses';

  @override
  String get unblock => 'Buka Blokir';

  @override
  String get block => 'Blokir';

  @override
  String get confirm_block_title => 'Konfirmasi Blokir?';

  @override
  String confirm_block_msg(Object charName) {
    return 'Setelah diblokir, Anda tidak akan menerima pesan dari $charName untuk sementara waktu.';
  }

  @override
  String get think_again => 'Pikirkan Lagi';

  @override
  String get confirm_block_btn => 'Konfirmasi Blokir';

  @override
  String get no_char_info => 'Belum ada informasi detail untuk karakter ini...';

  @override
  String get private_mailbox => 'Kotak Surat Pribadi';

  @override
  String get user_info_not_found => 'Informasi pengguna tidak ditemukan';

  @override
  String get load_failed => 'Gagal memuat, silakan coba lagi';

  @override
  String get empty_mailbox => 'Kotak surat saat ini kosong~';

  @override
  String get system_notification => 'Notifikasi Sistem';

  @override
  String get interaction_records => 'Catatan Interaksi';

  @override
  String get liked_content => 'Konten yang Disukai';

  @override
  String get my_favorites => 'Favorit Saya';

  @override
  String get login_to_view_records => 'Silakan login untuk melihat catatan';

  @override
  String get no_likes_yet => 'Anda belum menyukai postingan apa pun!';

  @override
  String get empty_favorites => 'Folder favorit kosong, yuk jelajahi Lobi!';

  @override
  String get theme_sakura_pink => 'Sakura Pink';

  @override
  String get theme_ocean_blue => 'Biru Laut';

  @override
  String get theme_sunset_orange => 'Oren Senja';

  @override
  String get theme_mint_forest => 'Hutan Mint';

  @override
  String get theme_midnight => 'Mode Malam';

  @override
  String get change_atmosphere => 'Ubah Suasana';

  @override
  String get custom_color => 'Warna Kustom';

  @override
  String get custom_color_desc => 'Racik warna suasana eksklusif Anda';

  @override
  String get cancel => 'Batal';

  @override
  String get confirm => 'Konfirmasi';
}
