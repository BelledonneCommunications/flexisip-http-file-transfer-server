{
  lib,
  php,
  src,
  stdenvNoCC,
  version,
}:

stdenvNoCC.mkDerivation {
  pname = "flexisip-http-file-transfer-server";
  inherit src version;

  nativeCheckInputs = [ php ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    for script in src/*.php; do
      php -n -l "$script"
    done

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0444 src/common.php src/download.php src/hft.php \
      -t "$out/share/flexisip-http-file-transfer-server"
    install -Dm0444 src/flexisip-http-file-transfer-server.conf \
      "$out/share/flexisip-http-file-transfer-server/examples/flexisip-http-file-transfer-server.conf"
    install -Dm0444 httpd/flexisip-http-file-transfer-server.conf \
      "$out/share/flexisip-http-file-transfer-server/examples/httpd.conf"
    install -Dm0444 logrotate/flexisip-http-file-transfer-server.conf \
      "$out/share/flexisip-http-file-transfer-server/examples/logrotate.conf"
    install -Dm0444 cron.d/flexisip-http-file-transfer-server \
      "$out/share/flexisip-http-file-transfer-server/examples/cron"
    install -Dm0444 README.md README.packaging.md \
      -t "$out/share/doc/flexisip-http-file-transfer-server"
    install -Dm0444 LICENSE.txt \
      "$out/share/licenses/flexisip-http-file-transfer-server/LICENSE.txt"

    runHook postInstall
  '';

  meta = {
    description = "Linphone-compatible RCS HTTP file-transfer server";
    homepage = "https://github.com/BelledonneCommunications/flexisip-http-file-transfer-server";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
  };
}
