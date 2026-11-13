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
        {{info}}
        <div>
            <button @click="fnPayment">구매하기</button>
            <button>제품 삭제</button>
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
                productId : "${productId}",
                info : {},
                sessionId : "${sessionId}"
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnInfo : function () {
                let self = this;
                let param = {
                    productId : self.productId
                };
                $.ajax({
                    url: "view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.info = data.info;
                    }
                });
            },
            fnPayment : function(){
                let self = this;
                IMP.request_pay(
                {
                    channelKey: "channel-key-81c94c54-7558-4388-bfcd-3b92f4980da6",
                    pay_method: "card",
                    merchant_uid: "payment-" + new Date().toLocaleString(), // 주문 고유 번호
                    name: self.info.productName,
                    amount: 1,
                    buyer_email: "gildong@gmail.com",
                    buyer_name: "홍길동",
                    buyer_tel: "010-4242-4242",
                    buyer_addr: "서울특별시 강남구 신사동",
                    buyer_postcode: "01181",
                },
                    function (response) {
                        // 결제 종료 시 호출되는 콜백 함수
                        // response.imp_uid 값으로 결제 단건조회 API를 호출하여 결제 결과를 확인하고,
                        // 결제 결과를 처리하는 로직을 작성합니다.
                        console.log(response);
                        if(response.success){
                            // alert("결제되었습니다!");
                            // 필요한 정보 db에 저장하는 로직 추가
                            self.fnOrder(response.paid_amount, response.merchant_uid);
                        } else {
                            alert(response.error_msg);
                        }
                    },
                );
            },
            fnOrder : function (price, merchantUid) {
                let self = this;
                let param = {
                    sessionId : self.sessionId,
                    productId : self.productId,
                    price : price,
                    merchantUid : merchantUid
                };
                $.ajax({
                    url: "add-order.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("구매 완료!");
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            console.log(self.productId);
            self.fnInfo();
        }
    });

    app.mount('#app');
</script>