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
% return the projection directions directly in the cell W.
% The function first uses the codes of Deng Cai for constructing matrices W
% and D for each modality for a given method. Then it makes the final
% matrix Wf and Df whos eigen-analysis is carried out to give the cell W
% for final projection.

%% Inputs
%       dataCell - It will be a cell containing data in different views each cell
% is a structure and will have two fileds
%       dataCell.data - data in each row
%       dataCell.label - column vector of label this should be needed whenever
% you are trying to make W or D using Supervised Mode.
%       options - This is the options structure which carries all the
%       options required to make matrices W and D.
% the W and D matrices which are then arranged accordingly to get the
% final eigen-value solution.
%% OUTPUT
% The cell containing the projection directions for each views. Each
% column is a projection direction.

%% COMMON NOTES ON THE PROGRAM FLOW AND VARIABLES USED WITH PURPOSE
% Program Flow
% step 1 - initialize various containers for each views to hold learned outputs
% step 2 - Dimensionality reduction before GMA (optional)
% step 3 - Construct W and D matrices for each view
% step 4 - construct the matrix Z1 and Z2 with different pairing options (refer to the eqn7 in paper )
% step 5 - Arrange the matrices accordingly to get the Big matrices Wf and Df
% step 6 - Tune the parameters (optional) I WOULD STRONGLY RECOMMEND TUNING IT YOURSELF BECAUSE I USED
%          A SIMPLE HEURISTIC TO SET THEM, BUT PPL HAVE REPORTED FAR BETTER RESULTS WHEN THEY TUNE IT PROPERLY
% step 7 - generalized eigen-value solution

% Common Notes
% 1. IT IS IMPORTANT TO UNDERSTAND THAT PCA IS REQUIRED BECAUSE MORE THAN OFTEN THE RESULTING MATRIX Df WILL BE
% ILL-CONDITIONED/SINGULAR BECAUSE OF 'LARGE D AND SMALL N' PROBLEM. THEREFORE, EITHER DIMENSIONLITY REDUCTION
% BEFORE GMA OR ADDING A REGULARIZATION TERM TO Bf WILL HELP.

% 2. Tune the parameters \gamma and \alpha (refer to eqn7) properly to get good results. A rule of thumb is to keep
% \alpha > 5*(sum(eig(Z1*Z2'))sum(eig(A1))), but it can be varied accordingly as well. For the parameter \gamma
% I used \gamma = sum(eig(B1))/sum(eig(B2)), but ppl have suggested some tuning based on cross-validation results in superior performance.


%% Getting different W and D

    nV = length(dataCell);
    W = cell(nV,1);
    D = cell(nV,1);

    Dim = zeros(nV,1);
    nS = zeros(nV,1);

    for i = 1:nV
        [nS(i), Dim(i)] = size(dataCell{i,1}.data); % each data sample in one row
    end

    % setting up arrays to hold eigen-vectors and means for different views if we want to carry out PCA before GMA
    if (isfield(options, 'PCA') && options.PCA)
        evFin = cell(nV,1); % PCA eigen-vectors to project data
        mPCA = cell(nV,1); % PCA means to subtract before projection
    end

    for i = 1:nV % loop over different views to get corresponding W and D matrices
        D{i,1} = eye(Dim(i));
        W{i,1} = (dataCell{i,1}.data)'*(dataCell{i,1}.data);
    end % end for loop

    vLabel = cell(nV,1);
    for i = 1:nV
        vLabel{i,1} = dataCell{i,1}.label;
    end

%% Now making the full matrix

    if (isfield(options,'AlignMode'))
        alignMode = options.AlignMode;
    else
        alignMode = 1; % Align all the samples
    end

    for i = 1:nV
        tmp = dataCell{i,1}.label;
        label = unique(tmp);
        Wout{i,1}.classMean = zeros(1,Dim(i));
        for c = 1 : length(label)
            fil = tmp == label(c);
            Wout{i,1}.classMean(c,:) =  mean(dataCell{i,1}.data(fil,:));
        end
    end


    switch alignMode
        case 1 % Align all samples
            for i = 1:nV
                Wout{i,1}.alignCol = dataCell{i,1}.data;
            end
        case 2 % Align class centres
            for i = 1:nV
                Wout{i,1}.alignCol = Wout{i,1}.classMean;
            end
        case 3 % Align after clustering
            k = options.NumCluster;
            for in = 1:nV
                Wout{in,1}.classLabel = label;
                Wout{in,1}.classID = cell(length(label),1);
                Wout{in,1}.classCent = cell(length(label),1);
                Wout{in,1}.alignCol = [];
                if in == 1
                    for c = 1:length(label)
                        fil = dataCell{in,1}.label == label(c);
                        tmp = dataCell{in,1}.data(fil,:);
                        [id, cC] = kmeans(tmp,k,'emptyaction','drop');
                        Wout{in,1}.classID{c,1} = id;
                        Wout{in,1}.classCent{c,1} =  cC;
                        Wout{in,1}.alignCol = [ Wout{in,1}.alignCol ; cC];
                    end
                else
                    for c = 1:length(label)
                        fil = dataCell{in,1}.label == label(c);
                        tmp = dataCell{in,1}.data(fil,:);
                        Wout{in,1}.classID{c,1} = Wout{1,1}.classID{c,1};
                        for inn = 1:k
                            fil1 = Wout{in,1}.classID{c,1} == inn;
                            Wout{in,1}.classCent{c,1}(inn,:) = mean(tmp(fil1,:));
                        end
                        Wout{in,1}.alignCol = [ Wout{in,1}.alignCol ; Wout{in,1}.classCent{c,1}];
                    end
                end
            end

        case 4
            if (isfield(options,'nPair') && options.nPair > 0)
            C1 = generateRandomPairs(vLabel,options.nPair);
            else
                options.nPair = length(vLabel{1,1})*2;
                C1 = generateRandomPairs(vLabel,options.nPair);
            end
            for i = 1:nV
                Wout{i,1}.alignCol = dataCell{i,1}.data(C1(:,i),:);
                Wout{i,1}.alignCol = [Wout{i,1}.alignCol; Wout{i,1}.classMean];
            end
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
    [eigVec, eigVal] = eigs(Wf,min(options.Factor,sum(Dim)),'LA',opts);

    for i = 1:nV
        Wout{i,1}.Bases = eigVec(sum(Dim(1:i-1))+1:sum(Dim(1:i)),:);
        Wout{i,1}.Evals = diag(eigVal);
        if isfield(options,'PCA')
            Wout{i,1}.evs = evFin{i,1};
            Wout{i,1}.mPCA = mPCA{i,1};
        end
    end
end