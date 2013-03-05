g2_initializeANSI()
{
  g2esc="\033"
  
  blackf="${g2esc}[30m";   redf="${g2esc}[31m";    greenf="${g2esc}[32m";
  yellowf="${g2esc}[33m"   bluef="${g2esc}[34m";   purplef="${g2esc}[35m";
  cyanf="${g2esc}[36m";    whitef="${g2esc}[37m";
  
  boldon="${g2esc}[1m";    boldoff="${g2esc}[22m";

  reset="${g2esc}[0m";
}

g2_initializeANSI

fatal() { echo -e "${redf}fatal: $1${reset}"; }
error() { fatal $1; exit 1; }
echo_info() { echo -e "${boldon}$1${reset}"; }