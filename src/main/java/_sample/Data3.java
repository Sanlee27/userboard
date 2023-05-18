package _sample;

// 필드정보은닉 + 필드캡슐화
public class Data3 {
	public int x; 
	private int y; // 정보은닉
	
	public int getX() { // 읽기 캡슐화 메서드
		return this.x; // this > 파이썬에선 self
	}
	
	public int getY() { // 읽기 캡슐화 메서드
		return this.y;
	}
	
	public void setX(int x) { // 쓰기 캡슐화 메서드
		this.x = x;
	}
	
	public void setY(int y) { // 쓰기 캡슐화 메서드
		this.x = y;
	}
	
	// Data3 d3_1 = new Data3();
	// Data3 d3_2 = new Data3();
}
