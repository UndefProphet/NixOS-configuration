{
  config,
  lib,
  pkgs,
  ...
}:
{
  name = "startup";
  order = 1;
  content = # lua
    ''
      hl.exec_cmd("${lib.getExe config.hj.programs.waypaper.package} --restore --backend awww")
      hl.exec_cmd("quickshell")
      hl.exec_cmd("awww-daemon")
      hl.exec_cmd("qpwgraph --minimized")
      hl.exec_cmd("${lib.getExe pkgs.vicinae} server")
    '';
}
