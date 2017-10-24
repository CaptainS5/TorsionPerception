function frameN = sec2frm(sec)
% translate time duration in seconds to in frame numbers

global prm
frameN = sec*prm.screen.refreshRate;

end

