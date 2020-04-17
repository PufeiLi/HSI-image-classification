clear;close all;clc

load('PaviaU.mat');%�������ݼ�
im = paviaU;       
[I_row,I_line,I_high] = size(im);%��ȡ���ݼ�3ά��С
im_all = im;
[I_row_all,I_line_all,I_high_all] = size(im_all);
im1_all = reshape(im_all,[I_row_all*I_line_all,I_high_all]);%����Ϊ2ά���� 
im1_all = im1_all';

load('PaviaU_gt.mat')%��������ǩ����
no_classes = length(unique(paviaU_gt))-1;

RandSampled{1}=[133 373 100 100 100 101 100 100 100];  %2
RandSampled{2}= RandSampled{1}*2;  %4
RandSampled{3}= RandSampled{1}*3; %6
RandSampled{4}= RandSampled{1}*4; %8
RandSampled{5}= RandSampled{1}*5; %10


K = no_classes;
Train_Label = [];
Train_index = [];
for ii = 1: no_classes
%  index_ii =  find(indian_pines_gt == ii);
   index_ii =  find(paviaU_gt == ii);
   class_ii = ones(length(index_ii),1)* ii;
   Train_Label = [Train_Label class_ii'];
   Train_index = [Train_index index_ii'];   
end 
%��������½����ݼ��Ͷ�Ӧ��ǩ����Ϊ1ά����

RandSampled_Num=RandSampled{3};
tr_lab = [];
tt_lab = [];
tr_dat = [];
tt_dat = [];

Index_train = {};
Index_test = {};
for i = 1: K
    W_Class_Index = find(Train_Label == i);%  ÿһ��ı�ǩ��λ��
    Random_num = randperm(length(W_Class_Index));
    Random_Index = W_Class_Index(Random_num);%��ÿһ������������������
    
    Tr_Index = Random_Index(1:RandSampled_Num(i)); %ÿ����ѡһ����������������������λ�� 
    Index_train{i} = Train_index(Tr_Index);%��һ��������������Ϊѵ����
    
    Tt_Index = Random_Index(RandSampled_Num(i)+1 :end);
    Index_test{i} = Train_index(Tt_Index);%ʣ�µ���Ϊ���Լ�

    tr_ltemp = ones(RandSampled_Num(i),1)'* i;
    tr_lab = [tr_lab tr_ltemp];
    tr_Class_DAT = im1_all(:,Train_index(Tr_Index));
    tr_dat = cat(2,tr_dat,tr_Class_DAT);%���ཫѵ������ǩ��ԭʼ��������Ϊһһ��Ӧ��
    
    tt_ltemp = ones(length(Index_test{i}),1)'* i;
    tt_lab = [tt_lab tt_ltemp];
    tt_Class_DAT = im1_all(:,Train_index(Tt_Index));
    tt_dat = cat(2,tt_dat,tt_Class_DAT);%���ཫ���Լ���ǩ��ԭʼ��������Ϊһһ��Ӧ��
end
[train_data,PS] = mapminmax(tr_dat,0,1);%��ԭʼ���ݹ�һ������
train_data=  train_data';    
train_label=tr_lab';

test_data = mapminmax('apply',tt_dat,PS);%��һ��
test_data =test_data';
test_label  =  tt_lab'; 

%%��ά�����
type_num = no_classes;


% method = [];
% method.mode = 'pca';
% method.K = 50;
% [train_data,U] = featureExtract(train_data,train_label,method,type_num);
% test_data = projectData(test_data, U, method.K);%�����Լ�����ѵ������ӳ�䷽ʽӳ�䵽�ռ���
% model = svmtrain(train_label,train_data,'-s 0 -c 10^5 t = 2'); %ʹ��rbf�˺���
% [pca_pre,~, ~] = svmpredict(test_label,test_data, model);
% [Acc_pca,AA_pca,OA_pca,Kap_pca,CM_pca] = EvalPara(pca_pre,test_label);
% save('pca_pred.mat','pca_pre');
% save('pca_cm.mat','CM_pca');
% fprintf('\n pca+svm Accuracy: %f\n',OA_pca);


% method = [];
% method.mode = 'lda';
% method.K = 100;
% [train_data,U] = featureExtract(train_data,train_label,method,type_num);
% test_data = projectData(test_data, U, method.K);%�����Լ�����ѵ������ӳ�䷽ʽӳ�䵽�ռ���
% model = svmtrain(train_label,train_data,'-s 0 -c 10^5 t = 2'); %ʹ��rbf�˺���
% [lda_pre,~, ~] = svmpredict(test_label,test_data, model);
% [Acc_lda,AA_lda,OA_lda,Kap_lda,CM_lda] = EvalPara(lda_pre,test_label);
% save('lda_pred.mat','lda_pre');
% save('lda_cm.mat','CM_lda');
% fprintf('\n lda+svm Accuracy: %f\n',OA_lda);


% method = [];
% method.mode = 'lpp';
% method.K = 100;
% method.weightmode = 'binary';
% method.knn_k = 5;

method = [];
method.mode = 'lpp';
method.K = 100;
method.weightmode = 'heatkernel';
method.t = 10;
method.knn_k = 7;
[train_data,U] = featureExtract(train_data,train_label,method,type_num);
test_data = projectData(test_data, U, method.K);%�����Լ�����ѵ������ӳ�䷽ʽӳ�䵽�ռ���
model = svmtrain(train_label,train_data,'-s 0 -c 10^5 t = 2'); %ʹ��rbf�˺���
[lpp_pre,ac, ~] = svmpredict(test_label,test_data, model);
[Acc_lpp,AA_lpp,OA_lpp,Kap_lpp,CM_lpp] = EvalPara(lpp_pre,test_label );
save('lpp_pred.mat','lpp_pre');
save('lpp_cm.mat','CM_lpp');
fprintf('\n lpp+svm Accuracy: %f\n',OA_lpp);

i_pre = 0;
ID = pred;
gt_new = zeros(1,I_row*I_line);
 for i=1:no_classes
   for j_train = 1:1:length(Index_train{i}) 
      gt_new(Index_train{i}(j_train))=i;
   end
   for j_test = 1:1:length(Index_test{i}) 
      gt_new(Index_test{i}(j_test))=ID(i_pre+j_test);
   end
   i_pre = i_pre+length(Index_test{i});
 end
%��SVM����Ľ���������������Ϊ2ά����      
gt_new1 = reshape(gt_new,I_row,I_line);

label2color(gt_new1,'uni');
figure,imshow(label2color(gt_new1,'uni'),[]),colormap jet
%��ͬ�������ϲ�ͬ����ɫ�����ͼ��

label2color(paviaU_gt,'uni');
figure,imshow(label2color(paviaU_gt,'uni'),[]),colormap jet





