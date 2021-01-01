function start()
    
    %1 Representing the first ID and 32 the last
    for i=2:37
        %This represents number of sessions
        for j=1:2
            if(i<10)
                stringID = append('0',int2str(i),'_',int2str(j));
            elseif(i >= 10)
                stringID = append(int2str(i),'_',int2str(j));
            end
            try
                %fprintf(stringID + "\n");
                eegPreprocessing(stringID);
            catch
                continue
            end
        end
    end

%eegPreprocessing('02_1');
end

function eegPreprocessing(dataSetName)
    %fprintf(append('C:\\Users\\auzri\\Desktop\\UTS\\UTS\\Research\\Data\\Raw\\', dataSetName, '.raw') + "\n");
    %dataSetName = '02_1'
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_fileio(append('C:\\Users\\auzri\\Desktop\\UTS\\UTS\\Research\\Data\\Raw\\', dataSetName, '.raw'), 'dataformat','auto');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',dataSetName,'gui','off'); 
    EEG=pop_chanedit(EEG, 'lookup','C:\\Users\\auzri\\Desktop\\UTS\\UTS\\Research\\Data\\Channel Location\\AdultAverageNet256_v1.sfp');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
    EEG = pop_rmbase( EEG, [],[]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
    EEG = pop_eegfiltnew(EEG, 'hicutoff',30,'plotfreqz',1);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
    EEG = eeg_checkset( EEG );
    EEG = pop_reref( EEG, [93 191] ,'keepref','on');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
    EEG = eeg_checkset( EEG );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',append('C:\\Users\\auzri\\Desktop\\UTS\\UTS\\Research\\Data\\Processed\\', dataSetName),'gui','off');
    EEG = pop_epoch( EEG, {  '2'  '4'  }, [-0.1         0.6], 'newname', append(dataSetName, ' Square'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',append('C:\\Users\\auzri\\Desktop\\UTS\\UTS\\Research\\Data\\Processed\\', dataSetName ,' Square2.set'),'gui','off'); 
    EEG = eeg_checkset( EEG );
    %EEG = pop_rmbase( EEG, [-100 0] ,[]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'overwrite','on','gui','off'); 
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0); 
    EEG = eeg_checkset( EEG );
    EEG = pop_epoch( EEG, {  '2'  }, [-0.1         0.6], 'newname', append(dataSetName, ' Random'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
    EEG = eeg_checkset( EEG );
    %EEG = pop_rmbase( EEG, [-100 0] ,[]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'savenew',append('C:\\Users\\auzri\\Desktop\\UTS\\UTS\\Research\\Data\\Processed\\',dataSetName,' Random2.set'),'overwrite','on','gui','off'); 
    %[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'name',dataSetName,'updatedat','off','commands',{{'index',2,'load',append('C:\\Users\\auzri\\Desktop\\UTS\\UTS\\Research\\Data\\Processed\\', dataSetName, ' Square.set'),'subject','S01','condition','Square'},{'index',3,'load',append('C:\\Users\\auzri\\Desktop\\UTS\\UTS\\Research\\Data\\Processed\\', dataSetName, ' Random.set'),'subject','S01','condition','Random'}} );
    %[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, 'channels', 'interpolate', 'on', 'recompute','on','erp','on');
    %tmpchanlocs = ALLEEG(1).chanlocs; STUDY = std_erpplot(STUDY, ALLEEG, 'channels', { tmpchanlocs.labels }, 'plotconditions', 'together');
end
