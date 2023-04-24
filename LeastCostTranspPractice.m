cost = [2 7 4 ; 3 3 1 ; 5 5 4 ; 1 6 2 ];
A = [5 8 7 14];
B = [7 9 18];
if sum(A) == sum(B)
    fprintf('Given problem is balanced \n');
else
    fprintf('Given Transportation Problem is Unbalanced \n');
    if sum(A)<sum(B)
        cost(end+1,:) = zeros(1, size(A,2));
        A(end+1) = sum(B) - sum(A);
    elseif sum(A)>sum(B)
        cost(:,end+1) = zeros(1,size(A,2));
        B(end+1) = sum(A)-sum(B);
    end
end
Icost = cost;
X = zeros(size(cost));
[m,n] = size(cost);
BFS = m+n-1;
for i=1:size(cost,1)
    for j=1:size(cost,2)
    hh = min(cost(:));
    [rowind, colind] = find(hh==cost);
    x11 = min(A(rowind),B(colind));
    [val,ind] = max(x11);
    ii = rowind(ind);
    jj = colind(ind);
    y11 = min(A(ii),B(jj));
    X(ii,jj) = y11;
    A(ii) = A(ii) - y11;
    B(jj) = B(jj) - y11;
    if(A(ii)==0)
    cost(ii,:) = inf;
    else
    cost(:,jj) = inf;
    end
    end
end
fprintf('Initial BFS = \n');
IB = array2table(X);
disp(IB);
totalBFS = length(nonzeros(X));
if totalBFS == BFS
    fprintf('Non-Degenerate \n');
else
    fprintf('Degenerate \n');
end
InitialCost = sum(sum(Icost.*X));
disp(InitialCost);



