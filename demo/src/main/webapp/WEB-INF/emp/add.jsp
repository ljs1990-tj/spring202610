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
        <h2>사원추가</h2>
        <hr>
        <div>
            <label>사번 : <input v-model="empNo"></label>
            <button>중복체크</button>
        </div>
        <div>
            <label>이름 : <input v-model="eName"></label>
        </div>
        <div>
            <label>직급 : <input v-model="job"></label>
        </div>
        <div>
            <label>급여 : <input v-model="sal"></label>
        </div>
        <div>
            <button @click="fnAdd">추가</button>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                empNo : "",
                eName : "",
                job : "",
                sal : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnAdd : function () {
                let self = this;
                let param = {
                    empNo : self.empNo,
                    eName : self.eName,
                    job : self.job,
                    sal : self.sal
                };
                $.ajax({
                    url: "http://localhost:8080/emp/add.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if(data.result == "success"){
                            alert("추가되었습니다!");
                            location.href="list.do";
                        } else {
                            alert("오류가 발생했습니다. \n나중에 다시 시도해주세요.");
                        }
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