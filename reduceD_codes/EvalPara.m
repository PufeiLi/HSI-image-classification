function [Acc_Cls,AA,OA,Kap,CM] = EvalPara(predicted_label,test_label )

%EVALPARA   ������ص���������
%    
%                a = accaracy_all;  ������ķ��ྫ��
%                b = AA_accaracy; ƽ�����ྫ��
%                c = OA_ACC;       ������ྫ��                   
%                d = Kappa;          kappaϵ��
%                e = ConfuMatrix;   ��������
%
%

clsNum =  length(unique(test_label));
ID = predicted_label;

for i = 1:clsNum
  in_i=find(test_label==i);
  bb_i=length(find(ID(in_i)==i));
  aa_i=length(find(test_label==i));
  accaracy_all(i)=bb_i/aa_i;%����ÿһ����ྫ��
end
OA_ACC=sum(ID==test_label)/length(test_label);%����OA
AA_accaracy = mean(accaracy_all );%����AA
accaracy_all=accaracy_all';
MatrixClassTable = [test_label,ID];
[ConfuMatrix,Kappa]=ClassifiEvaluate(MatrixClassTable,clsNum);%����Kappa

Acc_Cls = accaracy_all;
OA = OA_ACC;
AA = AA_accaracy;
Kap = Kappa;
CM = ConfuMatrix;
 
end

