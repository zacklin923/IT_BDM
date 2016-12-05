package com.zs.action.zmz.count;

import java.io.UnsupportedEncodingException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;

import org.apache.log4j.Logger;

import com.zs.action.IMyBaseAction;
import com.zs.action.MyBaseAction;
import com.zs.entity.ZmCall;
import com.zs.entity.ZmOaNumber;
import com.zs.entity.custom.ZmCallCount;
import com.zs.service.IService;
import com.zs.tools.ExcelExport;
import com.zs.tools.Page;
import com.zs.tools.WeekDateArea;

public class CallCountAction extends MyBaseAction implements IMyBaseAction{

	private IService ser;
	private Page page;
	private List<ZmCallCount> counts;
	private String filtrate;
	
	String result="callCount";
	String result_succ="succ";
	String result_fail="fail";
	String dates;
	String datee;
	

	Logger logger=Logger.getLogger(CallCountAction.class);
	
	//--------------------------------------------------------
	public String getFiltrate() {
		return filtrate;
	}
	public IService getSer() {
		return ser;
	}
	public void setSer(IService ser) {
		this.ser = ser;
	}
	public void setFiltrate(String filtrate) {
		this.filtrate = filtrate;
	}
	public Page getPage() {
		return page;
	}
	public void setPage(Page page) {
		this.page = page;
	}
	public List<ZmCallCount> getCounts() {
		return counts;
	}
	public void setCounts(List<ZmCallCount> counts) {
		this.counts = counts;
	}
	
	public String getDates() {
		return dates;
	}
	public void setDates(String dates) {
		this.dates = dates;
	}
	public String getDatee() {
		return datee;
	}
	public void setDatee(String datee) {
		this.datee = datee;
	}
	//----------------------------------------------------
	public void clearOptions() {
		filtrate=null;
		dates=null;
		datee=null;
		counts=null;
	}
	
	private void clearSpace() {
		if (filtrate!=null && !filtrate.equals("")) {
			filtrate=filtrate.trim();
		}else {
			filtrate="W";
		}
	}
	
	/**
	 * 组装count
	 */
	private void initCount(Date dateStart,Date dateEnd,List counts,int number) {
		//组装一个XtZmNumberCount
		ZmCallCount count=new ZmCallCount();
		count.setsTime(new Timestamp(dateStart.getTime()));
		count.seteTime(new Timestamp(dateEnd.getTime()));
		String hql="from ZmCall where CDate>='"+count.getsTime()+"' and CDate<='"+count.geteTime()+"' and CDate!=null";
		List list2=ser.find(hql, null);
		if (list2.size()!=0) {//如果为0就不要了
			count.setCount(list2.size());
			//这里填装周数、月数、年数这种信息
			count.setNumber(number);
			counts.add(count);
		}
	}
	
	/**
	 * 组装counts
	 * @param counts
	 * @param dt
	 * @throws ParseException
	 */
	private void initCounts(List<ZmCallCount> counts,String dt) throws ParseException {
		//获取两个头尾的时间
		ZmCall d1 = null,d2=null;
		String str="from ZmCall where CDate!=null ";
		String str1="from ZmCall where CDate!=null ";
		SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd");
		if(dates!=null&&datee!=null&&!dates.equals("")&&!datee.equals("")){
			if(dt.equals("W")){
				List datelist = WeekDateArea.weekdate(dates, datee);
				str=str+" and CDate <='"+datelist.get(0)+"'";
				str1=str1+" and CDate >='"+datelist.get(1)+"'";
			}
			if(dt.equals("M")){
				//获取月的最后一天
				Date edate = new Date(Integer.parseInt(datee.substring(0,4))-1900, Integer.parseInt(datee.substring(5)),0);
				str=str+" and CDate <='"+sdf.format(edate)+"'";
				str1=str1+" and CDate >='"+dates+"'";
			}
			if(dt.equals("Y")){
				//获取月的最后一天
				Date edate = new Date(Integer.parseInt(datee)-1900, 12,0);
				str=str+" and CDate <='"+sdf.format(edate)+"'";
				str1=str1+" and CDate >='"+dates+"'";
			}
		}
		str=str+" order by CDate desc";
		List list=ser.query(str, null, str, page, ser);
		if (list.size()>0) {
			d1=(ZmCall) list.get(0);//尾巴
		}
		str1=str1+" order by CDate asc";
		list=ser.query(str1, null, str1, page, ser);
		if (list.size()>0) {
			d2=(ZmCall) list.get(0);//头
		}
		if (d1!=null && d2!=null) {
			if (dt.equals("W")) {
				int weeknum =(int)((d1.getCDate().getTime()-d2.getCDate().getTime())/(1000*60*60*24))/7;
				for (int i = 0; i <=weeknum; i++) {
					Date tmp=new Date(d1.getCDate().getYear(), d1.getCDate().getMonth(), d1.getCDate().getDate()-7*i,0,0,0);
					Date dateStart=ser.weekDate(tmp).get(ser.KEY_DATE_START);
					Date dateEnd=ser.weekDate(tmp).get(ser.KEY_DATE_END);
					Calendar cas = Calendar.getInstance();
					Calendar cae = Calendar.getInstance();
					cas.setTime(dateStart);
					int week=cas.get(cas.WEEK_OF_YEAR);
					initCount(dateStart, dateEnd, counts,week);
				}
			}else if (dt.equals("M")) {
				//获取相差月数
				long ms=(d1.getCDate().getYear()-d2.getCDate().getYear())*12+(d1.getCDate().getMonth()-d2.getCDate().getMonth());
				//logger.debug(ms);
				for (int i = 0; i <= ms; i++) {
					Date dateStart=new Date(d1.getCDate().getYear(), d1.getCDate().getMonth()-i, 1,0,0,0);
					Calendar ca = Calendar.getInstance();    
					ca.set(1900+d1.getCDate().getYear(), 1+d1.getCDate().getMonth()-i, 0);
					Date dateTmp=ca.getTime();
					Date dateEnd=new Date(dateTmp.getYear(), dateTmp.getMonth(), dateTmp.getDate(),23,59,59);
					int m=dateStart.getMonth();
					initCount(dateStart, dateEnd, counts,m+1);
				}
			}else if (dt.equals("Y")) {
				//获得相差年数
				long ys=d1.getCDate().getYear()-d2.getCDate().getYear();
				for (int i = 0; i <= ys; i++) {
					Date dateStart=new Date(d1.getCDate().getYear()-i, 0, 1,0,0,0);
					Date dateEnd=new Date(d1.getCDate().getYear()-i, 11, 31,23,59,59);
					int y=dateStart.getYear();
					initCount(dateStart, dateEnd, counts,y+1900);
				}
			}
		}
	}
	
	
	
	
	public String queryOfFenye() throws UnsupportedEncodingException {
		String id=getRequest().getParameter("id");
		String cz=getRequest().getParameter("cz");//用于判断是否清理page，yes清理，no不清理
		if (page==null) {
			page=new Page(1, 0, 5);
		}
		if (cz!=null && cz.equals("yes")) {
			page=new Page(1, 0, 5);
			clearOptions();
		}
		clearSpace();
		counts=new ArrayList<ZmCallCount>();
		if(id!=null){
			/*
			由于是统计模块所以不需要按编号查询功能，但为了兼容，故保留，只不过其代码为空而已。
			*/
		}else {
			try {
				initCounts(counts,filtrate);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		JSONArray json=JSONArray.fromObject(counts);
		getRequest().setAttribute("json", json);
		return result;
	}
	
	public String gotoQuery() throws UnsupportedEncodingException {
		// TODO Auto-generated method stub
		return null;
	}
	
	public String add() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}


	public String delete() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	public String update() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	
	public String exportExc() throws Exception{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String filePath=getRequest().getRealPath("/")+"/files/export/zmz/总部呼叫系统账号维护统计.xls";
		String dayType = "周数";
		if(filtrate.equals("M")){
			dayType = "月数";
		}else if(filtrate.equals("Y")){
			dayType = "年数";
		}
		Object[] obj ={"序号","开始时间","结束时间",dayType,"维护数量"};
		Object objtmp[][]=new Object[counts.size()][5];
		for (int i = 0; i < objtmp.length; i++) {
			objtmp[i][0]=i+1;
			objtmp[i][1]=sdf.format(counts.get(i).getsTime());
			objtmp[i][2]=sdf.format(counts.get(i).geteTime());
			objtmp[i][3]=counts.get(i).getNumber();
			objtmp[i][4]=counts.get(i).getCount();
		}
		
		ExcelExport.OutExcel(obj, objtmp, filePath);
		getRequest().setCharacterEncoding("utf-8");
		return null;
	}
	
	
}