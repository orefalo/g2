g2_initializeANSI()
{
  g2esc="\033"
  
  blackf="${g2esc}[30m";   redf="${g2esc}[31m";    greenf="${g2esc}[32m";
  yellowf="${g2esc}[33m"   bluef="${g2esc}[34m";   purplef="${g2esc}[35m";
  cyanf="${g2esc}[36m";    whitef="${g2esc}[37m";
  
  blackb="${g2esc}[40m";   redb="${g2esc}[41m";    greenb="${g2esc}[42m";
  yellowb="${g2esc}[43m"   blueb="${g2esc}[44m";   purpleb="${g2esc}[45m";
  cyanb="${g2esc}[46m";    whiteb="${g2esc}[47m";

  boldon="${g2esc}[1m";    boldoff="${g2esc}[22m";
  italicson="${g2esc}[3m"; italicsoff="${g2esc}[23m";
  ulon="${g2esc}[4m";      uloff="${g2esc}[24m";
  invon="${g2esc}[7m";     invoff="${g2esc}[27m";

  reset="${g2esc}[0m";
}

g2_initializeANSI
