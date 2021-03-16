clear; 
close all;
clc;

% parameter
% N:Node set size
% p:The probability of an edge exists between two vertices
N = 1200;
p = 1;

switch N/200
    case 1
       E=xlsread('./data/data200-1000.xls','R125');
    case 2
       E=xlsread('./data/data200-1000.xls','R144');
    case 3
       E=xlsread('./data/data200-1000.xls','R164');
    case 4
       E=xlsread('./data/data200-1000.xls','R284');
    case 5
       E=xlsread('./data/data200-1000.xls','R2107');
   case 6
       E=xlsread('./data/Set1200.xls');
   case 7
       E=xlsread('./data/Set1400.xls');
   case 8
       E=xlsread('./data/Set1600.xls');
   case 9
       E=xlsread('./data/Set1800.xls');
   case 10
       E=xlsread('./data/Set2000.xls');
end
A = zeros(N);


% Generate graph
if N <=1000
for i = 1:N %200-100
    for k = i:N
        if i==k A(i,k)=0;
        elseif p>rand()  A(i,k) = sqrt((E(i,2) - E(k,2))^2 + (E(i,3) - E(k,3))^2); A(k,i)=A(i,k); 
        else A(i,k) = Inf; A(k,i) = Inf;
        end      
     end
end
else
for i = 1:N %1200-2000
    for k = i:N
        if i==k A(i,k)=0;
        elseif p>rand()  A(i,k) = sqrt((E(i,1) - E(k,1))^2 + (E(i,2) - E(k,2))^2); A(k,i)=A(i,k); 
        else A(i,k) = Inf; A(k,i) = Inf;
        end      
     end
end
end

% Parallelizing SDM algorithm
B2 = A;
C2 = 1./zeros(N);
% parpool('local',6);
tic
for m = 1:N
    parfor i = 1:N
        for j = 1:N
            for k = 1:N
                if A(i,k) + B2(k,j) < C2(i,j)
                    C2(i,j) = A(i,k) + B2(k,j);
                end
            end
        end 
    end
    if C2 == B2
        break;
    end
    B2 = C2;
end
toc

% SDM algorithm
flag = 1;
C3 = A;
s=0;
m=0;
tic 
while m < N && flag > 0
    flag = 0;
    for j = 1:N
        for k =1:N
            if A(j,k) < Inf
                s=A(j,k);
                for i = 1:N
                    if C3(i,k) > C3(i,j) + s
                       C3(i,k) = C3(i,j) + s;
                       flag = flag + i;
                    end
                end
            end
        end
    end
    m = m + 1;
end
toc; 

% Floyd algorithm
D1=A;
tic
for k=1:N
    for i=1:N
        if(D1(i,k)<Inf)
        for j=1:N
            if D1(i,k)+D1(k,j)<D1(i,j)
                D1(i,j)=D1(i,k)+D1(k,j);
            end
        end
        end
    end
end
toc






