public class JavaSource {

    public static void main(String[] args) {

        // 打印需要被Bash获取的信息
        int x = 10;
        System.out.println(x * 2);

        // 设置退出码, 方便Bash获取java程序的执行结果
        System.exit(0);            
    }

}