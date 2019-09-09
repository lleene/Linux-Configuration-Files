% INPUT ARRAY A OF BOOL REPRESENTING FLAT IMAGE
% OUTPUT SKILL SCRIPT fname TO BE LOADED BY CADENCE

function [A] = matlab_logogen(fname, A)
    fillc = logical(0) % PLACE MET on ZEROS
    grid = 1;
    slot_f = 15;
    slot_e = 4;
    fid = fopen(fname,'W+');
    cell_name = strsplit(fname,'.');
    fwrite(fid,['lib_name = "tsmc_c018_sealring_1p5m"']);
    fprintf(fid,'\n');
    fwrite(fid,['cell_name = "' cell_name{1} '"']);
    fprintf(fid,'\n');
    fwrite(fid,['id=dbOpenCellViewByType(lib_name cell_name "layout" "maskLayout" "w")']);
    fprintf(fid,'\n');
    A(2:size(A,1)+1,:)=A;
    A(1,:)=ones(size(A,2),1).*not(fillc); % SPACER
    A(size(A,1)+1,:)=ones(size(A,2),1).*not(fillc); % SPACER
    for i=1:size(A,1);
        for j=1:size(A,2);
	    if ( logical( A(i,j) ) == fillc )
		fwrite(fid,['dbCreateRect( id list("METAL5" "drawing") ' ...
		'list(' num2str(i*grid) ':' num2str(j*grid) ' ' num2str(i*grid+grid) ...
		':' num2str(j*grid+grid) '));']);
		fprintf(fid,'\n');
            end
            if ( mod( j , ( slot_f + slot_e ) ) < slot_f )
                fwrite(fid,['dbCreateRect( id list("METAL4" "drawing") ' ...
		'list(' num2str(i*grid) ':' num2str(j*grid) ' ' num2str(i*grid+grid) ...
		':' num2str(j*grid+grid) '));']);
		fprintf(fid,'\n');
            end
        end
    end
    fwrite(fid,['dbCreateRect( id list("DMEXCL" "dummy5") ' ...
    'list(' num2str(grid) ':' num2str(grid) ' ' num2str(i*grid+grid) ...
    ':' num2str(j*grid+grid) '));']);
    fprintf(fid,'\n');
    fwrite(fid,['leMergeShapes(id~>shapes)']);
    fprintf(fid,'\n');
    fwrite(fid,['dbSave(id lib_name cell_name "layout")']);
    fprintf(fid,'\n');
    fwrite(fid,['dbClose(id)']);
    fprintf(fid,'\n');
    fclose(fid);
    
end
