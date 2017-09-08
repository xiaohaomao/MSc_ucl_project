
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

Sample=[];


age_0=[];

imd07q=[];
state=[];
patid=[];
gender=[];
tage_0=[];





TIME_INTERVAL=[5,10];


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
    
    
    patid=[patid;sub_id];
    state=[state; reshape(repmat([1:5],[N_one_Sample,1])',[N_one_Sample*5,1])];
    imd07q=[imd07q;sub_imd];
    gender=[gender;sub_gender];
    
    time_interval=[];
    time_interval=TIME_INTERVAL(i);
    
   
 
    
    
    sub_age_0=[];
 
   
    
    sub_age_0=repmat(time_interval,[4,N_one_Sample]);

    
    
    age_0=[age_0;reshape(cumsum([sample_age;sub_age_0],1),[N_one_Sample*5,1])];

    tage_0=[tage_0;reshape(cumsum([zeros(1,N_one_Sample);sub_age_0],1),[N_one_Sample*5,1])];


end
age=[];
tage=[];

age=age_0;
tage=tage_0;
T_0=table(patid,age,tage,imd07q,gender,state);

writetable(T_0,'Sample_4_5.csv')

