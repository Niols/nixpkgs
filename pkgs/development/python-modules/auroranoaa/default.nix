{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "auroranoaa";
  version = "0.0.5";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "djtimca";
    repo = "aurora-api";
    rev = "refs/tags/${version}";
    hash = "sha256-bQDFSbYFsGtvPuJNMykynOpBTIeloUoCVRtIuHXR4n0=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "auroranoaa" ];

  meta = with lib; {
    description = "Python wrapper for the Aurora API";
    homepage = "https://github.com/djtimca/aurora-api";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
