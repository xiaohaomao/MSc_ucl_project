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


for i=1:N,
    
    if rand(1)<=0.9;
        % path state 1 -> state 2

        time_interval=[];
        
        time_interval(1)=mean(exprnd(8,[1,1]));
        if rand(1)<=0.9
            % path state 1 -> state 2 -> state 3
            time_interval(2)=mean(exprnd(8,[1,1]));
            
            if rand(1)<=0.9
                % path state 1 -> state 2 -> state 3 -> state 4 -> state 5
                time_interval(3)=mean(exprnd(8,[1,1]));
                time_interval(4)=mean(exprnd(8,[1,1]));
                patid=[patid;repmat(i,5,1)];
                state=[state;[1:5]'];
                imd07q=[imd07q;repmat(sample_imd(i),5,1)];
                gender=[gender;repmat(sample_gender(i),5,1)];
                age=[age;cumsum([sample_age(i),time_interval(1),time_interval(2),time_interval(3),time_interval(4)])'];
                age_copy=[age_copy;cumsum([sample_age_copy(i),time_interval(1),time_interval(2),time_interval(3),time_interval(4)])'];
                
             
                time_interval=[];

            else
                % state 1-> state 2 -> state 3 -> state 5
                patid=[patid;repmat(i,4,1)];
                state=[state;[1,2,3,5]'];
                imd07q=[imd07q;repmat(sample_imd(i),4,1)];
                gender=[gender;repmat(sample_gender(i),4,1)];
                
                
                
                time_interval(3)=mean(exprnd(8,[1,1]));
                age=[age;cumsum([sample_age(i),time_interval(1),time_interval(2),time_interval(3)])'];
                age_copy=[age_copy;cumsum([sample_age_copy(i),time_interval(1),time_interval(2),time_interval(3)])'];
                
                time_interval=[];
            end
            

            
        else
            % state 1-> state 2  -> state 5
            patid=[patid;repmat(i,3,1)];
            state=[state;[1,2,5]'];
            imd07q=[imd07q;repmat(sample_imd(i),3,1)];
            gender=[gender;repmat(sample_gender(i),3,1)];
            
            
            
            time_interval(2)=mean(exprnd(8,[1,1]));
            age=[age;cumsum([sample_age(i),time_interval(1),time_interval(2)])'];
            age_copy=[age_copy;cumsum([sample_age_copy(i),time_interval(1),time_interval(2)])'];
            
            time_interval=[];
        end
        

        
    else
        % state 1 -> state 5
        patid=[patid;repmat(i,2,1)];
        state=[state;[1,5]'];
        imd07q=[imd07q;repmat(sample_imd(i),2,1)];
        gender=[gender;repmat(sample_gender(i),2,1)];
        
        
        
        
        time_interval=mean(exprnd(8,[1,1]));
        age=[age;cumsum([sample_age(i),time_interval])'];
        age_copy=[age_copy;cumsum([sample_age_copy(i),time_interval])'];
        
        time_interval=[];
        
    end
end


T=table(patid,age,imd07q,gender,state);

writetable(T,'Sample_3.csv')
