<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            아이디 : <input v-model="userId">
        </div>
        <div>
            비밀번호 : <input v-model="pwd1">
        </div>
        <div>
            비밀번호 확인 : <input v-model="pwd2">
        </div>
        <div>
            이름 : <input v-model="userName">
        </div>
        <div>
            주소 : <input v-model="addr">
        </div>
        <div>
            <button @click="fnJoin">가입하기</button>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                userId : "",
                pwd1 : "",
                pwd2 : "",
                userName : "",
                addr : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnJoin : function () {
                let self = this;
                
                // 아래 코드 실행하기 전에 값 검증
                // 1. 아이디는 최소 5글자 
                if(self.userId.length < 5){
                    alert("아이디는 최소 5글자 입니다.");
                    return;
                }
                // 2. 아이디는 영어 소문자 + 숫자 조합, 영어로 시작
                const idRegex = /^[a-z](?=.*[a-z0-9])(?=.*\d)[a-z0-9]*$/;
                if(!idRegex.test(self.userId)){
                    alert("아이디는 영어 소문자+숫자 조합입니다. \n아이디는 소문자로 시작해야 합니다.");
                    return;
                }

                // 3. 비밀번호는 최소 8글자
                if(self.pwd1.length < 8 || self.pwd2.length < 8){
                    alert("비밀번호는 최소 8글자 입니다.");
                    return;
                }
                // 4. 비밀번호는 특수문자 필수 포함

                // 5. 비밀번호와 비밀번호 확인은 같아야 함.
                if(self.pwd1 != self.pwd2){
                    alert("비밀번호가 서로 다릅니다.");
                    return;
                }
                // 6. 이름은 한글만

                // 7. 이름, 주소는 빈 값 안됨
                if(self.userName == "" || self.addr == ""){
                    alert("필수값은 모두 입력해주세요!");
                    return;
                }

                let param = {
                    userId : self.userId,
                    pwd : self.pwd1,
                    userName : self.userName,
                    addr : self.addr
                };
                $.ajax({
                    url: "http://localhost:8080/join.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {

                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>