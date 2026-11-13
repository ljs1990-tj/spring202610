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
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
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
        <div v-if="!authFlg">
            아이디 : <input v-model="userId">
            <button @click="fnAuth">본인인증</button>
        </div>
        <div v-else>
            <h2>비밀번호 재설정</h2>
            <div>
                비밀번호 : <input v-model="pwd1" type="password">
            </div>
            <div>
                비밀번호 확인 : <input v-model="pwd2" type="password">
            </div>
            <div><button @click="fnEditPwd">변경</button></div>
        </div>
    </div>
</body>
</html>

<script>
    IMP.init("imp50081124");
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                authFlg : false,
                userId : "",
                pwd1 : "",
                pwd2 : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnAuth : function () {
                let self = this;
                // IMP.certification(param, callback) 호출
                IMP.certification(
                {
                    // param
                    channelKey: "",
                    merchant_uid: "AUTH" + new Date().toLocaleString(), // 주문 번호
                    m_redirect_url: "", // 모바일환경에서 popup:false(기본값) 인 경우 필수, 예: https://www.myservice.com/payments/complete/mobile
                    popup: false, // PC환경에서는 popup 파라미터가 무시되고 항상 true 로 적용됨
                },
                    function (rsp) {
                        // callback
                        console.log(rsp);
                        if (rsp.success) {
                        // 인증 성공 시 로직
                            // self.authFlg = true;
                            jQuery.ajax({
                                url: "/auth.dox",
                                method: "POST",
                                dataType: "json",
                                data: { 
                                    impUid : rsp.imp_uid,
                                    userId : self.userId 
                                },
                                success : function(data){
                                    console.log("인증 사용자 정보 => ", data);
                                    alert(data.message);
                                    if(data.success){
                                        self.authFlg = true;
                                    } 
                                }
                            });

                        } else {
                        // 인증 실패 시 로직
                        }
                    },
                );
            },
            fnEditPwd : function(){
                let self = this;
                if(self.pwd1 != self.pwd2){
                    alert("비밀번호 다르다!!!!!!!!!");
                    return;
                }
                let param = {
                    userId : self.userId,
                    pwd : self.pwd1
                };
                $.ajax({
                    url: "http://localhost:8080/edit-pwd.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("비밀번호 변경 됨!");
                        location.href = "/login.do"; 
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