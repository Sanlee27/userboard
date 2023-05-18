package vo;

import java.util.Calendar;

public class Person {
	private int birth; // field 은닉
	 
	/*
	 * private int getBirth() { // getter 은닉 return birth; }
	 * 	return birth;
	 */
	public void setBirth(int birth) {
		if(birth > 0) {
		this.birth = birth;
		}
	}	
	
	public int getAge() {
		if(this.birth > 0) {
		Calendar c = Calendar.getInstance();
		int y = c.get(Calendar.YEAR);
		return y - this.birth;
		}
		return 0;
	}
}
