
� ������ ����� ������������� ��� ����������� ��� ���������� ������ �
��������� ModelSim.

��� ��������� ���������� �������������� ������, ����� ��������
�������� ������� ��������� � ����� defines.vh. ����� � ���� �����
����� �������� ����� ������, ������� ����� ������������� � ��������
���������.

��� ���������� ��������� ���������� ��������� ��������� ��������:

  1) ����������� ���� � �������, � ���� � ����������� (���������
     /py_utils/util_for_sim.py) ��. README � ����� py_utils.

  2) ���������, ��� ����� ������ � ������� � ����������� �������������
     ��������� � ����� defines.vh. ����� ������� �������� ��������
     ��� ��������� �����, � ������ ��������� ������ 
     ( ���������:
        ��������� ������ (������������, ����������� ����� ������) �����
        �������� � ����� top_bloom.sv. ��������� HASH_CNT � HASH_WIDTH
        � ������ ���������� �� ������ � ���������! )

  3) ��������� ������ ��������� ��������� ��������:
       
       vsim -do make.do

  4) � ���� wave ����� ��������� ��� ������� � ������, ��� ���������
     ������ ����� � �������. � ���� transcript ������������ ����������
     � ���, ������� ����� ���� �������, � ������� ���� �������
     ���������.

  5) ����� ����, ��� ����� ���������� ��� ������, ���������� ��������
     ���������.

  6) ������ ����� ������� �������� ����, � ����������, � ����� ������
     �������� ��� ������ �������.