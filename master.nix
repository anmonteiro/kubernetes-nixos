{pkgs, ...}:

let nodeName = "ip-172-31-34-123.us-west-2.compute.internal";
in
{
  imports = [ <nixpkgs/nixos/modules/virtualisation/amazon-image.nix> ];
  ec2.hvm = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    kubectl
    vim
    bind
  ];

  services.kubernetes = {
    roles = ["master"];
    masterAddress = nodeName;
    easyCerts = true;
    apiserver = {
      basicAuthFile = pkgs.writeText "credentials.csv" ''
        admin,admin,admin
      '';
      extraOpts = ''
        --cloud-provider=aws
      '';
    };
    kubelet = {
      extraOpts = ''
        --cloud-provider=aws
      '';
    };
    controllerManager = {
      extraOpts = ''
        --cloud-provider=aws
      '';
    };
  };

  networking = {
    hostName = nodeName;
    firewall.enable = false;
  };

  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
}
