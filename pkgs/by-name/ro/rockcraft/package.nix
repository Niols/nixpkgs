{
  lib,
  python3Packages,
  fetchFromGitHub,
  dpkg,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "rockcraft";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "rockcraft";
    rev = version;
    hash = "sha256-2Bo3qtpSSfNvqszlt9cCc9/rurDNDMySAaqLbvRmjjw=";
  };

  pyproject = true;
  build-system = with python3Packages; [ setuptools-scm ];

  dependencies = with python3Packages; [
    craft-application
    craft-archives
    craft-platforms
    spdx-lookup
    tabulate
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      craft-platforms
      pytest-check
      pytest-mock
      pytest-subprocess
      pytestCheckHook
    ]
    ++ [ dpkg ];

  preCheck = ''
    mkdir -p check-phase
    export HOME="$(pwd)/check-phase"
  '';

  disabledTests = [
    "test_run_init_flask"
    "test_run_init_django"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "rockcraft";
    description = "Create OCI images using the language from Snapcraft and Charmcraft";
    homepage = "https://github.com/canonical/rockcraft";
    changelog = "https://github.com/canonical/rockcraft/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
