classdef CTimeleft < handle

    properties 
        t0
        charsToDelete = [];
        done
        total
        interval = 1;
    end
    
    methods
        function t = CTimeleft(total, interval)
            
            t.done = 0;
            t.total = total;
            if nargin>1
                t.interval = interval;
            else
                t.interval = ceil(total*t.interval/100);
            end
        end
        
        function [remaining status_string] = timeleft(t)
            if t.done == 0
                t.t0 = tic;
            end
                              
            t.done = t.done + 1;
            
            elapsed = toc(t.t0);
            
            if t.done == 1 || mod(t.done,t.interval)==0 || t.done == t.total || nargout > 0

                % compute statistics
                avgtime = elapsed./t.done;
                remaining = (t.total-t.done)*avgtime;
                
                if avgtime < 1
                    ratestr = sprintf('- %.2f iter/s', 1./avgtime);
                else
                    ratestr = sprintf('- %.2f s/iter', avgtime);
                end
                
                if t.done == 1
                    remaining = -1;
                    ratestr = [];
                end
                
                timesofarstr  = sec2timestr(elapsed);
                timeleftstr = sec2timestr(remaining);
                
                %my beloved progress bar
                pbarw = 30;
                pbar = repmat('.',1,pbarw);
                pbarind = 1 + round(t.done/t.total*(pbarw));
                pbar(1:pbarind-1) = '=';
                if pbarind < pbarw
                    pbar(pbarind) = '>';
                else
                        0;
                    
                end
                pbar = ['[',pbar,']'];
                
                
                status_string = sprintf('%s %03d/%03d - %03d%%%% - %s|%s %s ',pbar,t.done,t.total,...
                    floor(t.done/t.total*100),timesofarstr,timeleftstr, ratestr);
                
                delstr = [];
                if ~isempty(t.charsToDelete)
                    delstr = repmat('\b',1,t.charsToDelete-1);
                end
           
                if nargout == 0
                    fprintf([delstr status_string]);
                end
                
                t.charsToDelete = numel(status_string);
            end
            
            if t.done == t.total && nargout == 0 
                fprintf('\n');
            end
        end
    end
end
   


