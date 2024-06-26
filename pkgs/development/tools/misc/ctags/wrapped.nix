{
  lib,
  ctags,
  writeTextFile,
  runtimeShell,
  ctagsWrapped,
  name ? "${ctags.name}-wrapped",
  args ? lib.concatLists [
    ctagsWrapped.defaultArgs
    ctagsWrapped.phpLang
    ctagsWrapped.jsLang
    ctagsWrapped.nixLang
    ctagsWrapped.asLang
    ctagsWrapped.rubyLang
  ],
}:

# Define a ctags wrapper derivation adding support for some not-that-common languages customization.
# Override this to provide different args.

writeTextFile {
  inherit name;
  executable = true;
  destination = "/bin/${name}";
  text = ''
    #!${runtimeShell}
    exec ${ctags}/bin/ctags ${lib.concatStringsSep " " (map lib.escapeShellArg args)} "$@"
  '';
  derivationArgs = {
    # Inherit the metadata from the parent `ctags` derivation.
    inherit (ctags) meta;

    passthru = {
      # `ctagsWrapped` exists for backwards compatibility; ctagsWrapped used to be an attrset and
      # now is a derivation, so keep supporting the use of `ctagsWrapped.ctagsWrapped`.
      inherit ctagsWrapped;

      ### language arguments

      # don't scan version control directories
      defaultArgs = [
        "--exclude=.svn"
        "--exclude=.hg"
        "--exclude=.git"
        "--exclude=_darcs"
        "--sort=yes"
      ];

      # actionscript
      asLang = [
        "--langdef=ActionScript"
        "--langmap=ActionScript:.as"
        "--regex-ActionScript=/function[ \\t]+([A-Za-z0-9_]+)[ \\t]*\\(/\\1/f,function,functions/"
        "--regex-ActionScript=/function[ \\t]+(set|get)[ \\t]+([A-Za-z0-9_]+)[ \\t]*\\(/\\2/p,property,properties/"
        "--regex-ActionScript=/interface[ \\t]+[a-z0-9_.]*([A-Z][A-Za-z0-9_]+)/\\1/i,interface,interfaces/"
        "--regex-ActionScript=/package[ \\t]+([^ \\t]*)/\\1/p/"
        "--regex-ActionScript=/class[ \\t]+[a-z0-9_.]*([A-Z][A-Za-z0-9_]+)/\\1/c,class,classes/"
      ];

      # PHP
      phpLang = [
        "--langmap=PHP:.php"
        "--regex-PHP=/abstract class ([^ ]*)/\\1/c/"
        "--regex-PHP=/interface ([^ ]*)/\\1/i/"
        "--regex-PHP=/function[ \\t]+([^ (]*)/\\1/f/"
      ];

      # Javascript: also find unnamed functions and functions being passed within a dict.
      # the dict properties is used to implement duck typing in frameworks
      # var foo = function () { ... }
      # {
      # a : function () {}
      # only recognize names up 100 characters. Else you'll be in trouble scanning compressed .js files.
      jsLang = [ "--regex-JavaScript=/([^ \\t]{1,100})[ \\t]*:[ \\t]*function[ \\t]*\\(/\\1/f/" ];

      # find foo in "foo =", don't think we can do a lot better
      nixLang = [
        "--langdef=NIX"
        "--langmap=NIX:.nix"
        "--regex-NIX=/([^ \\t*]*)[ \\t]*=/\\1/f/"
      ];

      rubyLang = [
        "--langmap=RUBY:.rb"
        "--regex-RUBY=/class ([^ ]*)/\\1/c/"
        "--regex-RUBY=/^[ ]*module[ ]*([^ ]*)/\\1/m/"
      ];
    };
  };
}
