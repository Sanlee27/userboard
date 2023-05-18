package _sample;

public class A {
	public String getFirstName() {
		return "구디";
	}
	public String getSecondName() {
		return "아카데미";
	}
	public String getFullName() {
		return this.getFirstName() + this.getSecondName();
	}
}
// java application으로 실행 (톰캣x)