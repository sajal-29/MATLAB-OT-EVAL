clc;

c = [-1 3 -2];
nonzero = 3;
info = [3 -1 2; -2 4 0; -4 3 8];
b = [7; 12; 10];
a = eye(size(info,1));
A = [info a b];
cost = zeros(1,size(A,2));
cost(1:nonzero) = c;
BV = nonzero+1:size(A,2)-1;
zjcj = cost(BV)*A - cost;
zcj = [zjcj;A]; 
simptable = array2table(zcj);
simptable.Properties.VariableNames(1:size(zcj,2)) = {'x1','x2','x3','s1','s2','s3','sol'};
run = true;
while run
    zjcj = cost(BV)*A - cost;

    if any(zjcj<0)
        zc = zjcj(1:size(zjcj,2)-1);
        [EnterCol, pvtcol] = min(zc);
        sol = A(:,end);
        column = A(:,pvtcol);
        if all(A(:,pvtcol)<=0)
            error('Unbounded LPP');
        else
    
            for i=1:size(column,1)
                if column(i)>0
                    ratio(i) = sol(i)./column(i); 
                else
                    ratio(i) = inf;
                end
            end
            [MinRatio, pvt_row] = min(ratio);
            fprintf('Leaving variable is %d \n',BV(pvt_row));
        end
        BV(pvt_row) = pvtcol;
        disp('BV = ');
        disp(BV);
        pvt_key = A(pvt_row,pvtcol);
        A(pvt_row,:) = A(pvt_row,:)./pvt_key;
        for i=1:size(A,1)
            if i~= pvt_row
                A(i,:) = A(i,:) - A(i,pvtcol).*A(pvt_row,:);
            end
        end
       % zjcj = zjcj - zjcj(pvtcol).*A(pvt_row,:);
        zjcj = cost(BV)*A - cost;

    
    BFS = zeros(1,size(A,2));
    BFS(BV) = A(:,end);
    BFS(end) = sum(BFS.*cost);
    current_bfs = array2table(BFS);
    current_bfs.Properties.VariableNames(1:size(current_bfs,2)) = {'x1','x2','x3','s1','s2','s3','sol'};
    
    zcj = [zjcj;A];
    table = array2table(zcj);
    table.Properties.VariableNames(1:size(zcj,2)) = {'x1','x2','x3','s1','s2','s3','sol'};
    else
        run = false;
        fprintf('The current BFS is optimal \n');
        disp(table);
    end
end
