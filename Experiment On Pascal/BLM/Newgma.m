%https://github.com/huyt16/Twitter100k

%Written by 					Abhishek Sharma
%Please cite "Generalized Multiview Analysis: A discriminative Latent Space",

%@inproceedings{gma-cvpr12,
%  author    = {Abhishek Sharma and Abhishek Kumar and Hal Daume III and David W Jacobs},
%  title     = {Generalized Multiview Analysis: A discriminative Latent Space},
%  booktitle = {CVPR},
%  year      = {2012},
%  pages     = {2160 -- 2167},
%}

function Wout = Newgma(dataCell,options)
%% Getting different W and D

    nV = length(dataCell);
    W = cell(nV,1);
    D = cell(nV,1);

    Dim = zeros(nV,1);
    nS = zeros(nV,1);

    for i = 1:nV
        [nS(i), Dim(i)] = size(dataCell{i,1}.data); % each data sample in one row
    end
    
    for i = 1:nV % loop over different views to get corresponding W and D matrices
        switch options.method
            case 'BLM'
                D{i,1} = eye(Dim(i));
                W{i,1} = (dataCell{i,1}.data)'*(dataCell{i,1}.data);
            case 'GMMFA'
                options.gnd = dataCell{i,1}.label;
                gnd = dataCell{i,1}.label;
                [Wdumm,  Ddumm] = myMFA(gnd,options,dataCell{i,1}.data);
                Wdumm = full(Wdumm);
                Ddumm = full(Ddumm);
                W{i,1} = (dataCell{i,1}.data)'*Wdumm*(dataCell{i,1}.data);
                D{i,1} = (dataCell{i,1}.data)'*Ddumm*(dataCell{i,1}.data);
        end
    end % end for loop

    vLabel = cell(nV,1);
    for i = 1:nV
        vLabel{i,1} = dataCell{i,1}.label;
    end

%% Now making the full matrix
    switch options.method
        case 'BLM'
            for i = 1:nV
                Wout{i,1}.alignCol = dataCell{i,1}.data;
            end
            Wf = zeros(sum(Dim),sum(Dim));
            for r = 1:nV
                for c = r:nV
                    rs = sum(Dim(1:r-1))+1;
                    re = sum(Dim(1:r));
                    cs = sum(Dim(1:c-1))+1;
                    ce = sum(Dim(1:c));
                    if r == c
                        Wf(rs:re,cs:ce) = W{r,1};
                    else
                        tmp = Wout{r,1}.alignCol'*Wout{c,1}.alignCol*options.Lamda;
                        Wf(rs:re,cs:ce) = tmp;
                        Wf(cs:ce,rs:re) = tmp';
                    end
                end
            end

            Wf = (Wf + Wf')/2;
            opts.disp = 0;
            [eigVec, ~] = eigs(Wf,min(options.Factor,sum(Dim)),'LA',opts);

            for i = 1:nV
                Wout{i,1}.Bases = eigVec(sum(Dim(1:i-1))+1:sum(Dim(1:i)),:);
            end
            
        case 'GMMFA'
            for i = 1:nV
                Wout{i,1}.alignCol = dataCell{i,1}.data;
            end
            Wf = zeros(sum(Dim),sum(Dim));
            Df = zeros(sum(Dim),sum(Dim));
            for r = 1:nV
                for c = r:nV
                    rs = sum(Dim(1:r-1))+1;
                    re = sum(Dim(1:r));
                    cs = sum(Dim(1:c-1))+1;
                    ce = sum(Dim(1:c));
                    if r == c
                        Wf(rs:re,cs:ce) = W{r,1};
                        Df(rs:re,cs:ce) = D{r,1}*options.Mult(r) + options.ReguAlpha*eye(Dim(r));
                    else
                        tmp = Wout{r,1}.alignCol'*Wout{c,1}.alignCol*options.Lamda;
                        Wf(rs:re,cs:ce) = tmp;
                        Wf(cs:ce,rs:re) = tmp';
                    end
                end
            end

            Df = Df + options.ReguAlpha*eye(sum(Dim));
            Df = (Df + Df')/2;
            Wf = (Wf + Wf')/2;
            
            opts.disp = 0;
            [eigVec, ~] = eigs(Wf,Df,min(options.Factor,min(Dim)),'LA',opts);

            for i = 1:nV
                Wout{i,1}.Bases = eigVec(sum(Dim(1:i-1))+1:sum(Dim(1:i)),:);
            end
    end
end