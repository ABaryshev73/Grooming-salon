﻿

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.АвторДокумента) Тогда 
		Объект.АвторДокумента = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда 
		
		Если Параметры.Свойство("Начало") Тогда
			Объект.ДатаЗаписи = Параметры.Начало;
		КонецЕсли;
		
		Если Параметры.Свойство("Окончание") Тогда
			Объект.ДатаОкончанияЗаписи = Параметры.Окончание;
		КонецЕсли;
		
		Если Параметры.Свойство("Сотрудник") Тогда 
			Объект.Сотрудник = Параметры.Сотрудник;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.ДатаЗаписи) Тогда 
			Объект.Дата = НачалоДня(Объект.ДатаЗаписи);
		КонецЕсли;
	КонецЕсли;		
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры


&НаКлиенте
Процедура УслугиУслугаПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТЧ.Услуга) Тогда 
		СтрокаТЧ.Стоимость = РаботаСЦенами.ПолучитьЦенуТовараУслуги(СтрокаТЧ.Услуга);
	Иначе СтрокаТЧ.Стоимость = 0;
	КонецЕсли;
	
КонецПроцедуры 


&НаСервере
Процедура УстановитьДоступностьЭлементовФормы()
	Если РольДоступна("ПолныеПрава") Тогда 
		Элементы.УслугаОказана.ТолькоПросмотр = Ложь;
	КонецЕсли;
		
КонецПроцедуры // УстановитьДоступностьЭлементовФормы()

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Заказ записан");
	
КонецПроцедуры


