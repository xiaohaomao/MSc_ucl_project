% Number of sample
% started age
% IMD
% Gender
format short
N=10000;
sample_age=randi([45,49],[1,N]);
sample_imd=randi([1,5],[1,N]);
sample_gender=randi([1,2],[1,N]);
uniform_noise=rand([1,N]);
sample_age=sample_age+uniform_noise;

sample=sample_age+sample_imd*2+sample_gender*1.5;



age=[];
imd07q=[];
state=[];
patid=[];
gender=[];
tage=[];
time_interval=[];
    

for i=1:N,
    
    
    patid=[patid;repmat(i,5,1)];
    state=[state;[1:5]'];
    imd07q=[imd07q;repmat(sample_imd(i),5,1)];
    gender=[gender;repmat(sample_gender(i),5,1)];
    
   
    
    time_interval(1)=mean(exprnd(550/sample(i),[1,1]));
    
    time_interval(2)=mean(exprnd(550/(sample(i)+time_interval(1)),[1,1]));
    
    time_interval(3)=mean(exprnd(550/(sample(i)+time_interval(1)+time_interval(2)),[1,1]));
    time_interval(4)=mean(exprnd(550/(sample(i)+time_interval(1)+time_interval(2)+time_interval(3)),[1,1]));
    
    age=[age;cumsum([sample_age(i),time_interval],2)'];
    tage=[tage;cumsum([rand(1)/10,time_interval],2)'];
    
    
    time_interval=[];

end
        
   


T=table(patid,age,tage,imd07q,gender,state);


writetable(T,'Sample_1.csv')