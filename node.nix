{pkgs, ...}:
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
    roles = ["node"];
    masterAddress = "ip-172-31-34-123.us-west-2.compute.internal";
    easyCerts = true;
    kubelet = {
      extraOpts = ''
        --cloud-provider=aws
      '';
    };
  };

  networking = {
#    hostName = "ip-172-31-44-91.us-west-2.compute.internal";
    firewall.enable = false;
  };

  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
}
