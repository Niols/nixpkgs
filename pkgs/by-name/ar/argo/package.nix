{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, pkgsBuildBuild
}:

let
  # Argo can package a static server in the CLI using the `staticfiles` go module.
  # We build the CLI without the static server for simplicity, but the tool is still required for
  # compilation to succeed.
  # See: https://github.com/argoproj/argo/blob/d7690e32faf2ac5842468831daf1443283703c25/Makefile#L117
  staticfiles = pkgsBuildBuild.buildGoModule rec {
    name = "staticfiles";

    src = fetchFromGitHub {
      owner = "bouk";
      repo = "staticfiles";
      rev = "827d7f6389cd410d0aa3f3d472a4838557bf53dd";
      hash = "sha256-wchj5KjhTmhc4XVW0sRFCcyx5W9am8TNAIhej3WFWXU=";
    };

    vendorHash = null;

    excludedPackages = [ "./example" ];

    preBuild = ''
      cp ${./staticfiles.go.mod} go.mod
    '';

    ldflags = [ "-s" "-w" ];
  };
in
buildGoModule rec {
  pname = "argo";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo";
    tag = "v${version}";
    hash = "sha256-GRs6xF9/vZi5LdkDA4RkBR6ElvWi0uji/05h0Y7P2eU=";
  };

  vendorHash = "sha256-8+0iBtXNHyLwE6+AeDDQRERt0930kPIjhQ5abqEqey0=";

  doCheck = false;

  subPackages = [
    "cmd/argo"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  preBuild = ''
    mkdir -p ui/dist/app
    echo "Built without static files" > ui/dist/app/index.html

    ${staticfiles}/bin/staticfiles -o server/static/files.go ui/dist/app
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/argoproj/argo-workflows/v3.buildDate=unknown"
    "-X github.com/argoproj/argo-workflows/v3.gitCommit=${src.rev}"
    "-X github.com/argoproj/argo-workflows/v3.gitTag=${src.rev}"
    "-X github.com/argoproj/argo-workflows/v3.gitTreeState=clean"
    "-X github.com/argoproj/argo-workflows/v3.version=${version}"
  ];

  postInstall = ''
    for shell in bash zsh; do
      ${if (stdenv.buildPlatform == stdenv.hostPlatform)
        then "$out/bin/argo"
        else "${pkgsBuildBuild.argo}/bin/argo"
      } completion $shell > argo.$shell
      installShellCompletion argo.$shell
    done
  '';

  meta = with lib; {
    description = "Container native workflow engine for Kubernetes";
    mainProgram = "argo";
    homepage = "https://github.com/argoproj/argo";
    changelog = "https://github.com/argoproj/argo-workflows/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
    platforms = platforms.unix;
  };
}
