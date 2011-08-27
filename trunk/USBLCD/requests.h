/* ���� ������������ ���� �������� ����� ����� firmware � �� �����. �� ������
 *  ������ �������� USB numbers (� ����������� ���� ������), ������������ ���
 *  ������������ ����� ������ � ����������� USB.
 */

#ifndef __REQUESTS_H_INCLUDED__
#define __REQUESTS_H_INCLUDED__

#define CUSTOM_RQ_SET_STATUS    1
#define CUSTOM_RQ_SET_STATUS10   10
/* ��������� ��������� LED (���������). Control-OUT.
 * ������������� ������ ���������� � ���� "wValue" ����������� (control)
 *  ��������. ������� ������ OUT �� ����������. ��� 0 �������� ����� wValue 
 *  ��������� LED.
 */

#define CUSTOM_RQ_GET_STATUS    2
/* ��������� ��������� LED. Control-IN.
 * ��� ����������� �������� (control transfer) ��������� 1 ���� ������, ��� 
 *  ���������� ���������� ������� ��������� �����. ��������� ���������� � 
 *  ���� 0 �����.
 */

#endif /* __REQUESTS_H_INCLUDED__ */
