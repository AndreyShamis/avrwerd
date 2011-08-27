/* Этот заголовочный файл является общим между firmware и ПО хоста. Он задает
 *  номера запросов USB numbers (и опционально типы данных), используемые для
 *  коммуникации между хостом и устройством USB.
 */

#ifndef __REQUESTS_H_INCLUDED__
#define __REQUESTS_H_INCLUDED__

#define CUSTOM_RQ_SET_STATUS    1
#define CUSTOM_RQ_SET_STATUS10   10
/* Установка состояния LED (светодиод). Control-OUT.
 * Запрашиваемый статус передается в поле "wValue" управляющей (control)
 *  передачи. Никаких данных OUT не посылается. Бит 0 младшего байта wValue 
 *  управляет LED.
 */

#define CUSTOM_RQ_GET_STATUS    2
/* Получение состояния LED. Control-IN.
 * Эта управляющая передача (control transfer) вовлекает 1 байт данных, где 
 *  устройство отправляет текущее состояние хосту. Состояние передается в 
 *  бите 0 байта.
 */

#endif /* __REQUESTS_H_INCLUDED__ */
