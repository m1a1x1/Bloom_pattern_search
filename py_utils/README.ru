� ������ ����� ��������� ��� python-�������:

  - bloom_model.py - ����������� ������ ������ ����� �� ���������, 
                     ����������� ����, ��� ������������ � FPGA.

  - util_for_sim.py - ������� ��� ���������� ����� ��� ������ ����� �
                      FPGA.

����� ������� ���������� �������� ��������� ������ ������� CRC:

  1) �������� � ����� /py_utils ���������� ������ pycrc:

       git clone https://github.com/tpircher/pycrc 

  2) ������� � py_utils/pycrc � ������� ��� ������ ���� __init__.py

       touch __init__.py

  3) ��������������� ����� /pycrc ������. ������ ��� ������ � ������.

��������� �������� ������:

 bloom_model.py 
  
   ������� ��������� � �� �����:

     ����������: ��� ��������� ������ ���� ������� �����������.

     -s <FILE_NAME> - ������������ ��������. ��������� ���� �� ��������� (����������), �� ������� �����
                      ����������� ����� (��. example_strings).

     -d <FILE_NAME> - ������������ ��������. ��������� ���� �� ��������, � ������ �����
                      ����� �������� ��������.

     -o <FILE_NAME> - �������������� ��������. ��������� ����, ����
                      ����� �������� ������ �� ������, � ������� �� ��� ������ �������.
                      ���� �������� �� ������, ���� ���� �����
                      ���������� filtered_data.
             
     -h             - help.

   �������� ������:

     1) ������� ���� � ���������� ��� ������ (�� �������
        example_strings)

     2) ������� ���� � �������, � ������� ����� ����������� �����
        ���������.

     3) ��������� ������� (��������� ���� ����� ������ � ���������� �
        �������):

          python bloom_model.py -s example_strings -d example_data -o example_filt_data

     4) �������� ������ ����� ��������� �� �����, ��� ����������
        �����, ������� �������� ���������. �� ���������� ������ �����
        ������� ���������: � ������� ������� �� ����� ���� ����
        �������� � � ������� ������� bloom-������ ����� ��������.

     5) ����� �� ���������� ������ ����� ������ ���� example_filt_data
        �� �������� ��� ���������.
        
 util_for_sim.py

   ������� ��������� � �� �����:

     ����������: 1) �� ���� ����� ������� ����� �������� ������ ����
                    ��������.
                 2) �������� ����� .json ����� � ����� ������� ���
                    ������ ����� � FPGA ����� ������ ��������� ����������
                    util_for_sim.py � ��������� ���������� SIM_FNAME �
                    PM_STATE_FNAME ������ �������� ������.

     -i             - ������������ �������� ��� ������ �������������. ��� ������
                      util_for_sim.py -i ���������� ������������� ������, ���������
                      ����������� ��� ������ �����.

     -a <STRING>    - �������� ���� ������ STRING ��� ������� ��� ������.
                      �� ���������� ������ ������� � ����
                      example_settings ����� ��������� �����������
                      �������.

     -A <FILE_NAME> - �������� ��� �������, �� ����� FILE_NAME ���
                      �������� ��� ������.

     -r <STRING>    - ������� ������ STRING �� ������ ��������� ���
                      ������, ��� ���� � example_settings ��������� ���������������
                      ������ (�� ���� � FPGA ��� ������ ������� ��������� � �����
                      ��������).

     -S             - ������� ����������, � ���, ����� ������ ����
                      �������� (� ������� �� �����) � ������� ���
                      � FPGA ������, ��� ������ ���� �����.
  
   �������� ������:
   
     1) ���������������� ������:

          python util_for_sim.py -i

     2) �������� ������ ������ � ������ ��������� ��� ������:
 
          python util_for_sim.py -a google

        ��� �������� ������ �� �����:

          python util_for_sim.py -A example_strings

     3) �� ���������� ���������� ���� �����, ��������� ����
        example_settings. ���� ���� ���������� ����������� �
        ���������� ../testbench/

