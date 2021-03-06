package com.zs.service.impl;

import java.io.File;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;

import com.zs.entity.WhAllDate;
import com.zs.entity.WhOutRepair;
import com.zs.entity.WhThreeMeetingScout;
import com.zs.service.BaseService;
import com.zs.service.iDataImportService;
import com.zs.tools.ExcelImport;
import com.zs.tools.NameOfDate;

public class WhAllDateServiceImpl extends BaseService implements iDataImportService{

	private Logger log=Logger.getLogger(WhAllDateServiceImpl.class);
	
	public void importExcelData(String fileName, File file,String unum) {
		try {
			List<String[]> list=ExcelImport.getDataFromExcel(fileName,file);
			for (int i = 1; i < list.size(); i++) {
				try {
					WhAllDate ad=new WhAllDate(list.get(i)[0], transToDate(list.get(i)[1]), transToDate(list.get(i)[2]),
							transToDate(list.get(i)[3]), transToDate(list.get(i)[4]), transToDate(list.get(i)[5]),
							transToDate(list.get(i)[6]), transToDate(list.get(i)[7]));
					save(ad);
				} catch (Exception e) {
					log.error("数据格式错误:请注意填写的数据格式，另外不要留空，数字类型的没有就写0，文本类型的没有可以不写，时间类型的一定要写");
				}
			}
		} catch (Exception e) {
			log.error("文件错误：请确认是否使用了正确的模板");
		}
	}

	
}
