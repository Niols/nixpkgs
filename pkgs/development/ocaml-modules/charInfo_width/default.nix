{ lib, fetchzip, buildDunePackage, camomile_1, result }:

buildDunePackage rec {
  pname = "charInfo_width";
  version = "1.1.0";
  duneVersion = "3";
  src = fetchzip {
    url = "https://bitbucket.org/zandoye/charinfo_width/get/${version}.tar.bz2";
    sha256 = "19mnq9a1yr16srqs8n6hddahr4f9d2gbpmld62pvlw1ps7nfrp9w";
  };

  propagatedBuildInputs = [ camomile_1 result ];

  meta = {
    homepage = "https://bitbucket.org/zandoye/charinfo_width/";
    description = "Determine column width for a character";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
