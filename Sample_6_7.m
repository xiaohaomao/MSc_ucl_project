
% two fixed time interval
% Number of sample
% started age
% IMD
% Gender
N_interval=2;
N_one_Sample=10000;
N_total=N_one_Sample;


sample_age=randi([45,49],[1,N_total]);
sample_imd=randi([1,5],[1,N_total]);
sample_gender=randi([1,2],[1,N_total]);
uniform_noise=rand([1,N_total]);
sample_age=sample_age+uniform_noise;



% matrix_selected
index=[];
first_index=ones([1,N_one_Sample]);
index=randi([0,1],[3,N_one_Sample]);
finall_index=ones([1,N_one_Sample]);

index=sort(index,1,'descend');
index=[first_index;index;finall_index];
index=reshape(index,[5*N_one_Sample,1]);

Sample=[];


imd07q=[];
state=[];
patid=[];
gender=[];

age_0=[];



TIME_INTERVAL=[5,10];


length_vector=zeros([1,N_interval])';

for i=1:N_interval
    

    sub_id=[];
    sub_id=[(i-1)*N_one_Sample+1:1:i*N_one_Sample];
    sub_id=repmat(sub_id,[5,1]);
    
    sub_id=reshape(sub_id,[N_one_Sample*5,1]);
    
    sub_imd=[];
    sub_imd=sample_imd;
    sub_imd=repmat(sub_imd,[5,1]);
    sub_imd=reshape(sub_imd,[N_one_Sample*5,1]);
    
    sub_gender=[];
    sub_gender=sample_gender;
    sub_gender=repmat(sub_gender,[5,1]);
    sub_gender=reshape(sub_gender,[N_one_Sample*5,1]);
    
    sub_state=[];
    sub_state= reshape(repmat([1:5],[N_one_Sample,1])',[N_one_Sample*5,1]);
   

    
    
    % when the state number equal to 5 or 10
    time_interval=[];
    time_interval=TIME_INTERVAL(i);


    
    sub_age_0=[];


    sub_age_0=repmat(time_interval,[4,N_one_Sample]);
 
    
 
    sub_age_0=reshape(cumsum([sample_age;sub_age_0],1),[N_one_Sample*5,1]);

    raw_matrix_0=[];

    
    raw_matrix_0=[index,sub_id,sub_age_0,sub_imd,sub_gender,sub_state];
    
    % select the visit order for each individual
    fixed_matrix_0=raw_matrix_0(all(raw_matrix_0,2),:);
    

    
    length_of_one_sample=[];
    length_of_one_sample=size(fixed_matrix_0);
    length_vector(i)=length_of_one_sample(1);
    
    
    
    after_patid=fixed_matrix_0(:,2);
    
    after_age_0=fixed_matrix_0(:,3);

 
    
    after_imd=fixed_matrix_0(:,4);
    after_gender=fixed_matrix_0(:,5);
    after_state=fixed_matrix_0(:,6);
    

    age_0=[age_0;after_age_0];

    
    patid=[patid;after_patid];
    state=[state;after_state];
    imd07q=[imd07q;after_imd];
    gender=[gender;after_gender];
    
    
    
    
    





end

length_vector=cumsum(length_vector,1);

age=age_0;


T_0=table(patid,age,imd07q,gender,state);


vector=table(length_vector);




writetable(vector,'vector_test_24_08_000.csv');
writetable(T_0,'Sample_6_7');


