function [outputArg1,outputArg2] = DataCreate(data_name,train_ratio)
% @author by lipufei
%=======================================
% �����������ݼ���������һ����������ѵ�����Ͳ��Լ�
% ���������data_name:�߹������ݼ�����
%                     'pavia'       --  Pavia University scene
%                     'indian'     --  Indian Pines scene
%           train_ratio:ѵ�������� 0.02��0.04,0.06��0.08,0.1
% ���������outputArg1: train_index 
%           outputArg2: test_index
%=======================================
no_classes = [];
RandSampled = {};
% RandSampled_Num = {};

switch lower(data_name)
    case 'paviau'
        load('./datasets/PaviaU.mat');%�������ݼ�
        im = paviaU;       
        [I_row,I_line,I_high] = size(im);%��ȡ���ݼ�3ά��С
        im_all = im;
        [I_row_all,I_line_all,I_high_all] = size(im_all);
        im1_all = reshape(im_all,[I_row_all*I_line_all,I_high_all]);%����Ϊ2ά���� 
        im1_all = im1_all';

        load('./datasets/PaviaU_gt.mat')%��������ǩ����
        no_classes = length(unique(paviaU_gt))-1;
        
        %��������½����ݼ��Ͷ�Ӧ��ǩ����Ϊ1ά����
        Train_Label = [];
        Train_index = [];
        for ii = 1: no_classes
        %  index_ii =  find(indian_pines_gt == ii);
           index_ii =  find(paviaU_gt == ii);
           class_ii = ones(length(index_ii),1)* ii;
           Train_Label = [Train_Label class_ii'];
           Train_index = [Train_index index_ii'];   
        end 
        RandSampled{1}=[133 373 100 100 100 101 100 100 100];  %2
        RandSampled{2}= RandSampled{1}*2;  %4
        RandSampled{3}= RandSampled{1}*3; %6
        RandSampled{4}= RandSampled{1}*4; %8
        RandSampled{5}= RandSampled{1}*5; %10
    case 'indian'
        pass

end

K = no_classes;
RandSampled_Num=RandSampled{train_ratio*100/2};
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

train_data = tr_dat';
train_label = tr_lab';
test_data = tt_dat';
test_label = tt_lab';

switch lower(data_name)
    case "paviau"
        save(strcat('./datasets/',"pavia_train_data",num2str(train_ratio),'.mat'),'train_data');
        save(strcat('./datasets/',"pavia_train_label",num2str(train_ratio),'.mat'),'train_label');
        save(strcat('./datasets/',"pavia_test_data",num2str(train_ratio),'.mat'),'test_data');
        save(strcat('./datasets/',"pavia_test_label",num2str(train_ratio),'.mat'),'test_label');

    case "indian"
        save('./datasets/indian_train_data.mat','train_data');
        save('./datasets/indian_train_label.mat','train_label');
        save('./datasets/indian_test_data.mat','test_data');
        save('./datasets/indian_test_label.mat','test_label');        
end       
        

outputArg1 = Index_train;
outputArg2 = Index_test;
end

