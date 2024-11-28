{ pkgs, ... }:

{
  home.packages = with pkgs; [
    khard
  ];

  home.file = {
    ".config/khard/khard.conf".text = ''
      [addressbooks]
      [[contacts]]
      path = "~/.contacts/ade68564-23e0-f2cb-9f07-afe629979f45"

      [general]
      debug = no
      default_action = list
      editor = vim -i NONE
      merge_editor = vimdiff

      [contact table]
      # display names by first or last name: first_name / last_name
      display = first_name
      # group by address book: yes / no
      group_by_addressbook = no
      # reverse table ordering: yes / no
      reverse = no
      # append nicknames to name column: yes / no
      show_nicknames = no
      # show uid table column: yes / no
      show_uids = yes
      # sort by first or last name: first_name / last_name
      sort = last_name

      [vcard]
      # extend contacts with your own private objects
      # these objects are stored with a leading "X-" before the object name in the vcard files
      # every object label may only contain letters, digits and the - character
      # example:
      #   private_objects = Jabber, Skype, Twitter
      private_objects = Jabber, Skype, Twitter
      # preferred vcard version: 3.0 / 4.0
      preferred_version = 3.0
      # Look into source vcf files to speed up search queries: yes / no
      search_in_source_files = no
      # skip unparsable vcard files: yes / no
      skip_unparsable = no
    '';
  };

  # programs.khard = {
  #   enable = true;
  # };

    # settings = {
    #   # "[isaac_test]"= {
    #   #   path = "~/.contacts/ade68564-23e0-f2cb-9f07-afe629979f45";
    #   # };

    #   general = {
    #    default_action = "list";
    #    editor = ["vim" "-i" "NONE"];
    #    merge_editor = ["vimdiff"];
    #  };

    #  "contact table" = {
    #    display = "formatted_name";
    #    group_by_addressbook = false;
    #    reverse = false;
    #    show_uids = true;
    #    sort = "last_name";
    #    preferred_phone_number_type = ["pref" "cell" "home"];
    #    preferred_email_address_type = ["pref" "work" "home"];
    #  };

    #  vcard = {
    #    private_objects = ["Jabber" "Skype" "Twitter"];
    #  };
    # };

  accounts.contact.accounts.isaac = {
    # khard.enable = true;

    remote = {
      passwordCommand = ["${pkgs.pass}/bin/pass" "show" "vps.loisa.ac/radicale"];
      type = "carddav";
      url = "https://vps.loisa.ac/radicale/isaac/ade68564-23e0-f2cb-9f07-afe629979f45/";
      userName = "isaac";
    };

    local = {
      type = "filesystem";
      path = "~/.contacts/";
      fileExt = ".vcf";
    };

    vdirsyncer = {
      enable = true;
      conflictResolution = "remote wins";
      metadata = ["displayname" "color"];
      collections =  ["from a" "from b"];
    };
  };

  programs.vdirsyncer.enable = true;

  services.vdirsyncer = {
    enable = true;
    frequency = "*:0/30";
  };
}
