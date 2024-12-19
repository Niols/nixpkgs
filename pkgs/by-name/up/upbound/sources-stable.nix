# Generated by "update.sh stable" - do not update manually!
{
  version = "0.36.1";

  platformList = [
    "aarch64-linux"
    "x86_64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  archMap = {
    aarch64-linux = "linux_arm64";
    x86_64-linux = "linux_amd64";
    x86_64-darwin = "darwin_amd64";
    aarch64-darwin = "darwin_arm64";
  };

  fetchurlAttrSet = {

    aarch64-linux.docker-credential-up = {
      hash = "sha256-BnEQWK1Y4rCDEk5BgkUIeF0oK6C77AQZh6KWhS+MfqM=";
      url = "https://cli.upbound.io/stable/v0.36.1/bundle/docker-credential-up/linux_arm64.tar.gz";
    };
    x86_64-linux.docker-credential-up = {
      hash = "sha256-4A0Di92G/vi9NR/pH20E8aaSn/jYhduQbYH6aLL2R3E=";
      url = "https://cli.upbound.io/stable/v0.36.1/bundle/docker-credential-up/linux_amd64.tar.gz";
    };
    x86_64-darwin.docker-credential-up = {
      hash = "sha256-/i4VsDUk0B+htRv0UCjCLT1ByewO8UNHOMbbxqIfvvE=";
      url = "https://cli.upbound.io/stable/v0.36.1/bundle/docker-credential-up/darwin_amd64.tar.gz";
    };
    aarch64-darwin.docker-credential-up = {
      hash = "sha256-gaaaOfn8oOxjlYruGePFZ+e65cUgRJSlsr4iweVYdSE=";
      url = "https://cli.upbound.io/stable/v0.36.1/bundle/docker-credential-up/darwin_arm64.tar.gz";
    };
    aarch64-linux.up = {
      hash = "sha256-mxuDhdO0nZkozMsKiKcDPBscgrY0pSChJP5TUJz729E=";
      url = "https://cli.upbound.io/stable/v0.36.1/bundle/up/linux_arm64.tar.gz";
    };
    x86_64-linux.up = {
      hash = "sha256-oZ1RpPZAKzChRWKUhUcKPRXhqmf3FBXvpFCICMsWh+w=";
      url = "https://cli.upbound.io/stable/v0.36.1/bundle/up/linux_amd64.tar.gz";
    };
    x86_64-darwin.up = {
      hash = "sha256-a4QsXlfmmFhRYxC0yZ7yVIHmP8VUgggfOZSenMXGlKA=";
      url = "https://cli.upbound.io/stable/v0.36.1/bundle/up/darwin_amd64.tar.gz";
    };
    aarch64-darwin.up = {
      hash = "sha256-PPHlADbIiQ/CAF746lulvuHjwwo1V563K9Haf/7IjEI=";
      url = "https://cli.upbound.io/stable/v0.36.1/bundle/up/darwin_arm64.tar.gz";
    };
  };
}
